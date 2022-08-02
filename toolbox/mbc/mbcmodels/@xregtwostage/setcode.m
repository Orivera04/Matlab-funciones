function TS= setcode(TS,Bnds,g,Tgt);
% XRETWOSTAGE/SETCODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:15 $


TS.xregmodel= setcode(TS.xregmodel,Bnds,g,Tgt);
Tgt= gettarget(TS);
nl= nfactors(TS.Local);
ng = ngfactors(TS);
TgtG= Tgt(nl+1:end,:);

SameTgt= isSameTgt(TS,TgtG);

g= cell(1,nl);
TS.Local= setcode(TS.Local,Tgt(1:nl,:),g,Tgt(1:nl,:));

if SameTgt
    % remove coding from all global models
    g= cell(1,ng);
    TG= Tgt(nl+1:end,:);
    for i=1:length(TS.Global)
        TS.Global{i}= setcode(TS.Global{i},TG,g,TG);
    end
    if isa(TS.datum,'xregmodel')
        TS.datum= setcode(TS.datum,TG,g,TG);
    end
else
    g= cell(1,ng);
    TG= Tgt(nl+1:end,:);
    for i=1:length(TS.Global)
        TS.Global{i}= setcode(TS.Global{i},TG,g,gettarget(TS.Global{i}));
    end
    if isa(TS.datum,'xregmodel')
        TS.datum= setcode(TS.datum,TG,g,gettarget(TS.datum));
    end
end
