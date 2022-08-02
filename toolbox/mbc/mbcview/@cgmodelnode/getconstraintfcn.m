function handle = getconstraintfcn(obj)
%GETCONSTRAINTFCN Returns the function which calculates constraints

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

handle = @i_CalcConstraints;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_CalcConstraints(node,vars)

model = getdata(node);
if model.concheck
    out = model.evaluategrid(vars,'constraint');
else
    out = [];
end


