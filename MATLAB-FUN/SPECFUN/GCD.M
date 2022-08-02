function [g,c,d] = gcd(a,b)
%GCD	Greatest common divisor.
%	G = GCD(A,B) is the greatest common divisor of integers A and B.
%	G = GCD(0,0) is 0 by convention; all other GCDs are positive integers.
%
%	[G,C,D] = GCD(A,B) also returns C and D with G = A*C + B*D.
 
%	Algorithm: See Knuth Volume 2, Section 4.5.2, Algorithm X.
%	Author:    John Gilbert, Xerox PARC
%	Copyright (c) 1992 by Xerox Corporation.  All rights reserved.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
 
if round(a) ~= a | round(b) ~= b
        error('Requires integer input arguments.')
end
 
u = [1 0 abs(a)];
v = [0 1 abs(b)];
while v(3)
    q = floor( u(3)/v(3) );
    t = u - v*q;
    u = v;
    v = t;
end
 
c = u(1) * sign(a);
d = u(2) * sign(b);
g = u(3);
