
% binomial.m by David Terr, Raytheon, 5-11-04
% Given nonnegative integers n and m with m<=n, compute the 
% binomial coefficient n choose m. 

function bc = binomial(n,m)

if 2*m <= n
    m1 = m;
else
    m1 = n-m;
end

if n <= 100
    size = abs( n-m1 ) + 1;
    ps = pascal( size );
    bc = ps( size, m1+1 );
else    % suggested by Greg von Winckel to improve speed for large input
    bc = exp( gammaln(n+1) - gammaln(n-m+1) - gammaln(m+1) );
end
