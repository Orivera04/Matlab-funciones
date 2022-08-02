function out = peveval(thing)
%PEVEVAL Evaluate pev
%
%  Y = PEVEVAL(EXPR) evaluates PEV for the expresssion EXPR.  If PEV is not
%  supported, this method will return a scalar NaN.
%
%  See also: CGEXPR/PEVCHECK, CGEXPR/EVALUATE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:09:09 $

if isempty(thing)
    out = [];
else
    % Normal expressions cannot calculate PEV
    out = NaN;
end