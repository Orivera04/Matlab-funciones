
% qftimes.m by David Terr, Raytheon, 11-17-04

% Compose (multiply) two binary quadratic forms and reduce result.
% This function requires rqf.m.

% Reference: H. Cohen, "A Course in Computational Algebraic Number Theory",
%               Springer-Verlag, Vol. 138 (1993), pp. 241 (Algorithm 5.4.6)

function f3 = qftimes(f1,f2)

% Make sure inputs have the right size.
if ( size(f1) ~= [1 3] )
    error('First argument needs to be a row vector of length 3.');
    return;
end

if ( size(f2) ~= [1 3] )
    error('Second argument needs to be a row vector of length 3.');
    return;
end

a1 = f1(1);
b1 = f1(2);
c1 = f1(3);
D = b1^2 - 4*a1*c1;

a2 = f2(1);
b2 = f2(2);
c2 = f2(3);

if ( b2^2 - 4*a2*c2 ~= D )
    error( 'Discriminants of inputs are not equal.' );
    return;
end

s = (b1 + b2)/2;
n = (b1 - b2)/2;

[d1 u v] = gcd(a1,a2);
[d t w] = gcd(d1,s);
d0 = gcd(gcd(d,c1),gcd(c2,n));

a3 = d0*a1*a2/d^2;
b3 = b2 + 2*a2*(v*(s-b2)-w*c2)/d;
c3 = (b3^2 - D)/(4*a3);

f3 = rqf([a3 b3 c3]);
f3 = f3{1};

