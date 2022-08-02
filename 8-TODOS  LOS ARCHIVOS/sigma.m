
% sigma by David Terr, Raytheon Inc., 5-19-04

% Given a nonnegative integers k and n, return the sum of the kth powers of
% the divisors of n. For example, sigma(1,6) = 1 + 2 + 3 + 6 = 12 and 
% sigma(2,6) = 1^2 + 2^2 +3^2 + 6^2 = 50. sigma(0,n) is just the number of
% divisors of n.

% Note: This program requires first downloading factor2.

function s = sigma(k,n)

if n==0
    s=0;
    return;
end

if n==1
    s=1;
    return;
end

fax = factor2(n);

if k==0
    s = prod(fax(:,2) + 1);
    return;
else
    s = 1;
    len = length(fax(:,1));
    
    for m=1:len
        p = fax(m,1);
        q = p^k;
        e = fax(m,2);
        s = s * (q^(e+1) - 1)/(q - 1);
    end
end


    