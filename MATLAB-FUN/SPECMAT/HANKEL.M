function h = hankel(c,r)
%HANKEL	Hankel matrix.
%	HANKEL(C) is a square Hankel matrix whose first column is C and
%	whose elements are zero below the first anti-diagonal.
%	HANKEL(C,R) is a Hankel matrix whose first column is C and whose
%	last row is R.
%	Hankel matrices are symmetric, constant across the anti-diagonals,
%	and have elements H(i,j) = R(i+j-1).
%
%	See also TOEPLITZ.

%	J.N. Little 4-22-87
%	Revised 1-28-88 JNL
%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = c(:);
nc = max(size(c));

if nargin == 1
    h = zeros(nc,nc);
    for j=1:nc
        h(1:nc-j+1,j) = c(j:nc);
    end
else
    r = r(:);
    nr = max(size(r));
    h = zeros(nc,nr);
    if c(nc) ~= r(1)
        disp(' ')
        disp('Column wins anti-diagonal conflict.')
    end
    for j=1:nr
        if j <= nc
            h(:,j) = [c(j:nc); r(2:j)];
        else
            h(:,j) = r(j-nc+1:j);
        end
    end
end
