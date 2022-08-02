function m=xregmodel(varargin)
% XREGMODEL base class for all MBC models
%
% m= xregmodel;
% m= xregmodel('nfactors',nf);
%
% The XREGMODEL class is the base, abstract, model class for use with MBC. 
% The model class is responsible for transformations in x and y for both 
% fitting and evaluation tasks. Bad data is also removed in model/lsfit 
% before estimating the model.
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:53:27 $

if nargin==1  
   m=varargin{1};
   if isa(m,'struct')
		m= i_UpdateOld(m);
	elseif isa(m,'xregmodel')
		return
	else
		error('Invalid input')
   end
else
   if nargin==2 & strcmp(varargin{1},'nfactors')
      Nf= varargin{2};
   else
      Nf=1;
   end
   
   
   m.version=5;
   % Transformation of y variable (either empty or an inline object)
   m.ytrans = '';
   % Inverse Transformation of y variable (either empty or an inline object)
   m.yinv   = '';
   
   % X transformation [min,max] -> [-1,1]. 
   % x' = 2*(g(x) - (g(min)+g(max))/2 )/(g(max)-g(min))
   % A nonlinear transformation can be specified using the inline object, g.
   % It is also possible to set a different target range
   
   m.code   = struct('min',-1,'max',1,'g','',...
      'mid',num2cell(zeros(1,Nf)),'range',2);
   
   % dependent factor info
   xsym= cell(Nf,1);
   xunits= xsym;
	ju= junit;
   for i=1:Nf;
      xunits{i,1}= ju;
      xsym{i}= sprintf('X%1d',i);
   end
   m.Xinfo= struct('Names',{repmat({''},Nf,1)},...
      'Units',{xunits},...
      'Symbols',{xsym});
   
   % independent factor info
   m.Yinfo= struct('Name','y',...
      'Units',ju,...
      'Symbol','y');   
   m.Comments  = '';
   
   % xregmodel/fitmodel will call this method
   m.FitAlgorithm = 'leastsq';
   % transform both sides
   m.TransBS = 0;
	
	
	% new version 4 properties
	m.Stats.Rinv = [];
	m.Stats.mse = 0;
	m.Stats.df  = Inf;
    m.Stats.Summary=[];
    
	% version 6 properties
	m.Outliers= [];
	
end
   
m= class(m,'xregmodel');




function m= i_UpdateOld(m)

if m.version<3
	
	% new fields for version 3
	m.version = 3;        
	
	% update coding structure to include range field
	c= m.code;
	if ~isempty(c)
		if ~isfield(c,'mid')
			% version 1 didn't have this field
			for i=1:length(c)
				c(i).mid= (c(i).max+c(i).min)/2;
			end
		end
		% new coding field   Target interval= [-1,1]
		[c.range]= deal(2);
	else
		% make empty structure
		c   = struct('min',{},'max',{},'g',{},'mid',{},'range',{});
	end
	m.code= c;
	
	% version 2 stored variable info in store field as a hack
	% this cleans up everything and makes a new structure
	OldStore= m.store;
	m= mv_rmfield(m,'store');
	if isempty(OldStore)
		% make some default values
		nf= max(length(c),1);
		xsym= cell(nf,1);
		xunits= repmat({junit},nf,1);
		for i=1:nf;
			xsym{i}= sprintf('X%1d',i);
		end
		OldStore= struct('Name','Y',...
			'YUnits',junit,...
			'Symbols',{xsym},...
			'XUnits', {xunits},...
			'Comments','');
	end
	% new xinfo structure
	m.Xinfo= struct('Names',{OldStore.Symbols},...
		'Units',{OldStore.XUnits},...
		'Symbols',{OldStore.Symbols});   % won't be cells
	% new yinfo structure
	m.Yinfo= struct('Name',OldStore.Name,...
		'Units',OldStore.YUnits,...
		'Symbol',OldStore.Name);   % won't be cells
	m.Comments  = OldStore.Comments;
	
	% fitmodel will call this method
	m.FitAlgorithm = 'leastsq';
	% transform both sides
	m.TransBS = 0;
end
if m.version<4
	% new version 4 properties for storing stats info 
	m.version=4;
	m.Stats.Rinv = [];
	m.Stats.mse = 0;
	m.Stats.df  = Inf;
    m.Stats.Summary=[];
end
if m.version<6
	m.Outliers= [];
end

