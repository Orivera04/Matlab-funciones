function y = fftshift(x)
%FFTSHIFT Move zeroth lag to center of spectrum.
%	Shift FFT.  For vectors FFTSHIFT(X) returns a vector with the
%	left and right halves swapped.  For matrices, FFTSHIFT(X) swaps
%	the first and third quadrants and the second and fourth quadrants.
%	FFTSHIFT is useful for FFT processing, moving the zeroth lag to
%	the center of the spectrum.

%	J.N. Little 6-23-86
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(x);
m1 = 1:ceil(m/2);
m2 = ceil(m/2)+1:m;
n1 = 1:ceil(n/2);
n2 = ceil(n/2+1):n;

% Note: can remove the first two cases when null handling is fixed.
if m == 1
    y = [x(n2) x(n1)];
elseif n == 1
    y = [x(m2); x(m1)];
else
    y = [x(m2,n2) x(m2,n1); x(m1,n2) x(m1,n1)];
end

