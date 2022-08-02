function y = mean(x)
%MEAN	Average or mean value.
%	For vectors,  MEAN(X)  is the mean value of the elements in X.
%	For matrices,  MEAN(X) is a row vector containing the mean value
%	of each column.
%
%	See also MEDIAN, STD, MIN, MAX.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(x);
if m == 1
    m = n;
end
y = sum(x) / m;
