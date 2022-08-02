function H = invhilb(n) 
%INVHILB Inverse Hilbert matrix.
%	INVHILB(N) is the inverse of the N by N matrix with elements
%	1/(i+j-1), which is a famous example of a badly conditioned
%	matrix.  The result is exact for  N  less than about 15.
%
%	See also HILB.

%	C. Moler, 4-30-87.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

p = n;
H = zeros(n);
for i = 1:n
    if i > 1, p = ((n-i+1)*p*(n+i-1))/(i-1)^2; end
    r = p*p;
    H(i,i) = r/(2*i-1);
    for j = i+1:n
        r = -((n-j+1)*r*(n+j-1))/(j-1)^2;
        H(i,j) = r/(i+j-1);
        H(j,i) = r/(i+j-1);
    end
end
