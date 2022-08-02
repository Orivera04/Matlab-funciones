function c = lcm(a,b)
%LCM	Least common multiple.
%	LCM(A,B) is the least common multiple of positive integers A and B.
%
%	See also GCD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if round(a) ~= a | round(b) ~= b | a < 1 | b < 1
	error('Input arguments must contain positive integers.');
end
c = a*b/gcd(a,b);
