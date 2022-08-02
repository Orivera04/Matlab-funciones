function TS= xregtwostage(LMod,GMods,Datum,m);
%XREGTWOSTAGE two-stage hierarchical model
%
%  TS= xregtwostage(LMod,GMods,Datum,xregmodel);
%  TS= xregtwostage(LMod,m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:00:22 $


loadstr=0;

cmodel= xregcovariance('','tscov');
if nargin== 0;
	% default properties
   LMod= localpspline([2 2]);
   m= xreg3xspline;
   c= struct('min',-1,'max',1,'g','','mid',0,'range',2);
   c= c(ones(1,4));
   set(m,'code',c);
   GM= m;
   GMods= {m m m m};
   Datum= m;
elseif nargin==1 & isa(LMod,'struct')
	% load old object (from loadobj)
   loadstr=1;
   TS= LMod;
   LMod= TS.Local;
   GMods= TS.Global;
   if isempty(GMods)
      ng= nfactors(TS.xregmodel)-nfactors(LMod);
      GM= xregcubic('nfactors',ng);
      set(GM,'order',zeros(1,ng));
   else
      GM= GMods{1};
   end
   Datum= TS.datum;
	m= TS.xregmodel;
   if isfield(TS,'PEV')
		% move PEV store to model
      PEV= TS.PEV;
      TS= mv_rmfield(TS,'PEV');
      % define model variance
      m= var(m,PEV,0,Inf);
   end
	if isfield(TS,'covmodel')
		% old covariance model
		cmodel= TS.covmodel;
	end
	% remove base model object so we can reconstruct this
   TS= mv_rmfield(TS,'xregmodel');
elseif nargin==2
   GM= GMods;
	if DatumType(LMod)
		Datum= GM;
	else
		Datum= [];
	end
	GMods= repmat({GM},numfeats(LMod),1);
else
   GM= GMods{1};
end

% version number
TS.version= 3;
if DatumType(LMod)
   LMod= datum(LMod,0);
end
   
% different models
TS.Local= LMod; 
TS.Global= GMods;
TS.datum= Datum;

if nargin<4 & ~loadstr
	% define base model object
   nf= nfactors(LMod)+nfactors(GM);
   m= xregmodel('nfactors',nf);
end

% 2nd stage covariance model
TS.covmodel= cmodel;
% logical array indicating whether to consider the global error as a random effect
TS.RandomEffects= true(length(TS.Global),1);

TS=class(TS,'xregtwostage',m);

if ~loadstr
	% update model info
	TS= modelinfo(TS,GM);
end
superiorto('sweepset','double');


function TS=modelinfo(TS,m);
% copy coding from global and local models to the twostage model

L= TS.Local;

% first clean out coding from global models for efficient evaluation
c= get(m,'code');
TgtG=gettarget(m);

SameTgt= isSameTgt(TS,TgtG);

[BndG,gG]= getcode(m);

if SameTgt
    g2= gG;
    [g2{:}]= deal('');
    % making the target [-Inf Inf] makes code(m,x) x->x
    Tgt=TgtG;
    Tgt(:,1)= -Inf;
    Tgt(:,2)=  Inf;
    TgtGs= sort(TgtG,2);
end

xiG= xinfo(m);
xiG.Names(:)={''};
xiG.Symbols(:)={''};
xiG.Units(:)={''};

for i=1:length(TS.Global)
   % empty code in global models
   if SameTgt && ~isempty(c)
      TS.Global{i}= setcode(TS.Global{i},TgtGs,g2,Tgt);   
   end
	TS.Global{i}= xinfo(TS.Global{i},xiG);
    % clear the pev matrix from the rf model
    TS.Global{i}= var(TS.Global{i},[],[],[]);
end
if isa(TS.datum,'xregmodel')
   % empty code
   if SameTgt
       TS.datum= setcode(TS.datum,TgtGs,g2,Tgt);   
   end
   TS.datum= xinfo(TS.datum,xiG);
   % clear the pev matrix from the datum model
   TS.datum= var(TS.datum,[],[],[]);
end

% twostage coding

nf= nfactors(TS);
nl= nfactors(L);
% local coding
[BndL,gL,TgtL]= getcode(L);
TgtL= gettarget(L);
Tgt= TgtL;
Tgt(:,1)= -Inf;
Tgt(:,2)=  Inf;
TgtLs= sort(TgtL,2);

g= gL;
g(:)={''};
TS.Local= setcode(L,TgtLs,g,Tgt);
% combine coding
if SameTgt
    TS= setcode(TS,[BndL;BndG] ,[gL(:);gG(:)],[TgtLs;TgtGs]);
else
    % no coding for global models in TS object
    TgtG(:,1)= -Inf;
    TgtG(:,2)= Inf;
    TS= setcode(TS,[BndL;BndG] ,[gL(:);gG(:)],[TgtLs;TgtG]);
end

xli= xinfo(L);
xgi= xinfo(m);
oldxi= xinfo(TS);
% Combine model info

xi.Names=    [xli.Names(:)   ;  xgi.Names(:)  ];
if length(xi.Names)~= nf
   % unit length might need fixing
   xi.Names= oldxi.Names;
end
xi.Units=    [xli.Units(:)   ;  xgi.Units(:)  ];
if length(xi.Units)~= nf
   % unit length might need fixing
   xi.Units= oldxi.Units;
end
xi.Symbols=  [xli.Symbols(:) ;  xgi.Symbols(:)];
if length(xi.Units)~= nf
   xi.Symbols= oldxi.Symbols;
end   

TS= xinfo(TS,xi);
TS= yinfo(TS,yinfo(L) );

