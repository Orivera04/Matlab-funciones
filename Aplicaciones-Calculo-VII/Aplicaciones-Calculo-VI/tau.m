
% tau by David Terr, Raytheon Inc., 5-19-04

% Given a nonnegative integer n, return tau(n), where tau is the Ramanujan
% tau function, defined as the coefficient of x^n in the Taylor expansion of 
% x * prod_{k>=1}(1-x^k)^24. tau(n) has some fascinating number theoretic
% properties.

% Note: This program requires first downloading factor2 and sigma.

function t = tau(n)

if n==0
    t = 0;
    return;
end

if n==1
    t = 1;
    return;
end

if n==2
    t = -24;
    return;
end

if isprime(n)==1
    m = (n-1)/2;
    s5os5 = zeros(1,m);
    
    for k=1:m
        s5os5(k) = sigma(5,k)*sigma(5,n-k);
    end
    
    t = (65 * sigma(11,n) + 691 * (sigma(5,n) - 504*sum(s5os5))) / 756;
else
    fax = factor2(n);
    len = length(fax(:,1));
    p = fax(1,1);
    
    if len==1   % n is a prime power
        t = tau(p) * tau(n/p) - p^11 * tau(n/p^2);
        return;
    else
        e = fax(1,2);
        q = p^e;
        t = tau(q) * tau(n/q);
        return;
    end
end

t = round(t);
