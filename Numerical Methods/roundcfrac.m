
% roundcfrac.m by David Terr, Raytheon Inc., 6-7-04
% Modified on 7-19-04 (modified rounding)
% Modified on 7-29-04 (round rational convergents added)

% roundcfrac(x,n) returns the first n round continued fraction coefficients of a given
% nonnegative real number x. Half-integers are rounded to the nearest
% integer with least absolute value. The second and third columns contain
% the numerators and denominators of the round rational convergents
% respectively, possibly each negated. These correspond to some but
% not all the ordinary rational convergents.

% Warning: If n is set too large, fewer coefficients may be returned and
% the last coefficient may be incorrect, due to rounding errors.

function c = roundcfrac(x,n)

c = zeros(n,3);
t = x;
k = 1;
p1 = 1;
p2 = 0;
q1 = 0;
q2 = 1;
done = 0;

while k<=n && ~done
    a = myround(t);
    c(k,1) = a;
    r = t - a;
    c(k,2) = r;
    p = a*p1 + p2;
    q = a*q1 + q2;
    c(k,2) = p;
    c(k,3) = q;
    
    if r==0 || x == p/q;
        done = true;
    else
        t = 1/r;
        k = k + 1;
        p2 = p1;
        q2 = q1;
        p1 = p;
        q1 = q;
    end
end

c = c(1:min(k,n),1:3);


function mr = myround( x )

mr = round( x );

if ( x - floor( x ) == 0.5 )
    if ( x > 0 ) 
        mr = mr - 1;
    else
        mr = mr + 1;
    end
end