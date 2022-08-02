function Y = i_eval(N);
%I_EVAL Evaluate expression
%
%  Y = I_EVAL(N,X) evaluates a 1-D Look up table N at the points specified
%  by the  column vector X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:14:00 $

if isempty(N)
    Y = NaN;
else
    x = N.Breakpoints;
    y = N.Values;
    if ~N.Extrapolate
        Y = eval(cgmathsobject, 'linear1', x, y, max(min(x),min(max(x), N.Xexpr.i_eval)));
    else
        Y = eval(cgmathsobject, 'linear1', x, y, N.Xexpr.i_eval);
    end
end
