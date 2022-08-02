function Y=i_eval(NF,X);
% cgNormFunction\i_eval
% Y=i_eval(NF,X)
% i_evaluates a 1-D Look up table NF at the points specified by the 
% column vector X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:50 $

% Check to see if the object is full
if isempty(NF)
    Y=nan;
else
    x = NF.Breakpoints;
    y = NF.Values;
    V = NF.Clips;
    Y = min(V(2),max(V(1),eval(cgmathsobject,'linear1',x,y,NF.Xexpr.i_eval)));
end
