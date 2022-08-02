function SameTgt= isSameTgt(TS,TgtG);
%XREGTWOSTAGE/ISSAMETGT same target fopr all global models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:59:44 $

if nargin<2
    nl= nlfactors(TS);
    Tgt= gettarget(TS);
    TgtG= Tgt(nl+1:end,:);
end
tol= sqrt(eps);    
SameTgt = true;
for i=1:length(TS.Global)
    SameTgt = SameTgt && norm(gettarget(TS.Global{i})-TgtG) < tol;
end
if SameTgt && isa(TS.datum,'xregmodel');
    SameTgt = SameTgt && norm(gettarget(TS.datum)-TgtG) < tol;
end
