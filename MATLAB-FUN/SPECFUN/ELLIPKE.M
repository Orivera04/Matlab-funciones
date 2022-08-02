function [k,e] = ellipke(m)
%ELLIPKE Complete elliptic integrals.
%	[K,E] = ELLIPKE(M) returns the value of the complete elliptic
%	integrals of the first and second kinds, evaluated at M.  As currently
%	implemented, M is limited to 0 < M < 1.
%	The accuracy of ELLIPKE(M) is EPS.
%
%	Be sure you don't confuse the modulus K with the parameter M -
%	they are related in the following way:  M = K^2

%	L. Shure 1-9-88
%	Modified to include the second kind by Bjorn Bonnevier
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%   ELLIPKE uses the method of the arithmetic-geometric mean
%   described in [1].

%   References:
%   [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%       Functions" Dover Publications", 1965, 17.6.

if any(any(imag(m)))
	error('Input arguments must be real.')
end
a0 = 1;
b0 = sqrt(1-m);
s0 = m;
i1 = 0; mm = 1;
while mm > eps
	a1 = (a0+b0)/2;
	b1 = sqrt(a0.*b0);
	c1 = (a0-b0)/2;
	i1 = i1 + 1;
	w1 = 2^i1*c1.^2;
	mm = max(max(w1));
	s0 = s0 + w1;
	a0 = a1;
	b0 = b1;
end
k = pi./(2*a1);
e = k.*(1-s0/2);
im = find(m ==1);
if ~isempty(im)
	if isieee
		e(im) = ones(max(size(im)),1);
		k(im) = e(im)*inf;
	else
		error('Result is infinite.')
	end
end

