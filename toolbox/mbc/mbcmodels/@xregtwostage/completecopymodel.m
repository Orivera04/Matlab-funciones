function TS= completecopymodel(TS);
% XREGTWOSTAGE/COMPLETECOPYMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:27 $

% twostage info
yi= yinfo(TS.xregmodel);
xi= xinfo(TS.xregmodel);
Tgt= gettarget(TS);

% extract 
nl= nfactors(TS.Local);
XL= xi;
XL.Names   = XL.Names(1:nl);
XL.Symbols = XL.Symbols(1:nl);
XL.Units   = XL.Units(1:nl);

TgtL= Tgt(1:nl,:);
g= cell(nl,1);
% copy local info
TS.Local = xinfo(TS.Local,XL);
TS.Local = setcode(TS.Local,TgtL,g,TgtL);
TS.Local = yinfo(TS.Local,yi);
TS.Local = completecopymodel(TS.Local);

% Global Factors
TgtG= Tgt(nl+1:end,:);
g= cell(size(TgtG,1),1);
if isSameTgt(TS)
    for i=1:length(TS.Global);
        TS.Global{i}= setcode(TS.Global{i},TgtG,g,TgtG);
    end
    
    if isa(TS.datum,'xregmodel')
        TS.datum= setcode(TS.datum,TgtG,g,TgtG);
    end
end

% i/o info
XG= xi;
XG.Names   = xi.Names(nl+1:end);
XG.Symbols = xi.Symbols(nl+1:end);
XG.Units   = xi.Units(nl+1:end);


for i=1:length(TS.Global)
    TS.Global{i}= xinfo(TS.Global{i},XG);
    TS.Global{i}= completecopymodel(TS.Global{i});
end
if isa(TS.datum,'xregmodel')
    TS.datum= xinfo(TS.datum,XG);
    TS.datum= completecopymodel(TS.datum);
end
