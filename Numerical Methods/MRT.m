
function [row, mi] = MRT(a, b)

% The Minimum Ratio Test (MRT) performed on vectors a and b.
% Output parameters:
% row - index of the pivot row
% mi - value of the smallest ratio. 

m = length(a);
c = 1:m;
a = a(:);
b = b(:);
l = c(b > 0);
[mi, row] = min(a(l)./b(l));
row = l(row);
