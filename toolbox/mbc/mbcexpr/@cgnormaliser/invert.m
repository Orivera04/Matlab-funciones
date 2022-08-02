function x = invert(LT,y);
%INVERT  Inverts a cgnormaliser.
%
% For cgnormaliser LT,
%   x = invert(LT,y)
% returns x such that LT(x) = y.
% 
% y can be a vector or array.  x will be the same size.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:27:42 $

if isempty(y)
    x = y;
else
    val = LT.Values;
    BP = LT.Breakpoints;

    % This line depends on us having monotonically increasing breakpoints.
    x = eval(cgmathsobject,'linear1',val,BP,y);
end
