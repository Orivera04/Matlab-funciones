
% factor2 by David Terr, Raytheon Inc., 5-19-04

% Given an integer n, return the prime factorization of n as a
% 2*k matrix, with the k distinct prime factors in the left column and
% exponents in the right column. Here, -1 is counted as a prime.

% For example, factor2(12) returns the matrix 2 2 and factor2(-12) returns -1 1
%                                             3 1                           2 2
%                                                                           3 1

function fac = factor2( n )

if n == 0 || n == 1
    fac = [n 0];
    return;
end

if n < 0
    fac = [-1 1;factor2(-n)];
    return;
end

fac0 = factor(n);
len = length(fac0);
fac1 = zeros(len,2);
p = fac0(1);
q = p;
fac1(1,1) = p;
fac1(1,2) = 1;
m = 1;
k = 2;

while k <= len
    
    q = fac0(k);
    
    while (q == p && k < len)
        fac1(m,2) = fac1(m,2) + 1;
        k = k + 1;        
        q = fac0(k);
    end
    
    if q == p
        k = k + 1;
        fac1(m,2) = fac1(m,2) + 1;
    else
        p = q;
        m = m + 1;
        fac1(m,1) = q;
        fac1(m,2) = 1;
        k = k + 1;
    end
    
end

fac = fac1(1:m,:);

