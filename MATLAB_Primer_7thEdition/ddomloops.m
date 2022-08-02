function B = ddomloops(A,tol)
% B = ddomloops(A) returns a
% diagonally dominant matrix B by modifying
% the diagonal of A.

[m n] = size(A) ;
if (nargin == 1)
    tol = 100 * eps ;
end
for i = 1:n
    d = A(i,i) ;
    a = abs(d) ;
    f = 0 ;
    for j = 1:n
        if (i ~= j)
            f = f + abs(A(i,j)) ;
        end
    end
    if (f >= a)
        aii = (1 + tol) * max(f, tol) ;
        if (d < 0)
            aii = -aii ;
        end
        A(i,i) = aii ;
    end
end
B = A ;
