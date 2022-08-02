function Value= get(TS,Property)
%XREGTWOSTAGE/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:59:40 $


if nargin==1
   Value= {'Local','Global','datum','datumtype','pev',get(TS.xregmodel)};
   return
end
switch lower(Property)
case 'local'
   L=TS.Local;
	[Bnds,g,Tgt]=getcode(TS);
	nl= nfactors(L);
	L= setcode(L,Bnds(1:nl,:),g(1:nl),Tgt(1:nl,:));
    
    L= completecopymodel(L);
	Value= L;
case 'global'
   Value= TS.Global;
	xi= i_gxinfo(TS);
    if isSameTgt(TS)
        [Bnds,g,Tgt]=getcode(TS);
        nl= nfactors(TS.Local)+1;
        Bnds= Bnds(nl:end,:);
        g= g(nl:end);
        Tgt= Tgt(nl:end,:);
        for i=1:length(Value)
            Value{i}=setcode(Value{i},Bnds,g,Tgt );
            Value{i}= xinfo(Value{i},xi);
        end
    else
        for i=1:length(Value)
            Value{i}= xinfo(Value{i},xi);
        end
    end
    for i=1:length(Value)
        % Value{i}= completecopymodel(Value{i});
    end

case 'datum'
   Value= TS.datum;
   if isa(Value,'xregmodel')
		xi= i_gxinfo(TS);
        if isSameTgt(TS)
            [Bnds,g,Tgt]=getcode(TS);
            nl= nfactors(TS.Local)+1;
            Bnds= Bnds(nl:end,:);
            g= g(nl:end);
            Tgt= gettarget(TS.datum);
            Value=setcode(Value,Bnds,g,Tgt );
        end
        Value= xinfo(Value,xi);
        Value= completecopymodel(Value);
   end
case 'baseglobal'
    if isempty(TS.Global)
        m= xregcubic('nfactors',ngfactors(TS));
    else
        m= TS.Global{1};
    end
    % coding
    [Bnds,g,Tgt]=getcode(TS);
    nl= nfactors(TS.Local)+1;
    Bnds= Bnds(nl:end,:);
    g= g(nl:end);
    Tgt= gettarget(m);
    m=setcode(m,Bnds,g,Tgt );
    % input info;
    xi= i_gxinfo(TS);
    Value= xinfo(m,xi);
    Value= completecopymodel(Value);
    
case 'datumtype'
   Value= DatumType(TS.Local);
otherwise
   try
      Value= get(TS.xregmodel,Property);
   catch
      error(['XREGTWOSTAGE/GET - Invalid Property ',Property])
   end
end   


function xi= i_gxinfo(TS)

xi= xinfo(TS);
nl= nfactors(TS.Local);
xi.Names(1:nl)=[];
xi.Symbols(1:nl)=[];
xi.Units(1:nl)=[];
