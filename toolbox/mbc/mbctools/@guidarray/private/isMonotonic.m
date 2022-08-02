function IS_MONOTONIC = isMonotonic(value)
%GUIDARRAY/ISMONOTONIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

% Is value a logical index
% if islogical(value)
%     IS_MONOTONIC = 1;
%     return
% end
% Initialse the loop variables
i = 1;
numValues = length(value);
% Loop until the end of the array or not monotonic - Note this loop is JIT
% compiled and hence faster than vectorised code
while i < numValues && value(i+1) > value(i)
    i = i + 1;
end
% Was monotonic if entire array was covered
IS_MONOTONIC = i == numValues;