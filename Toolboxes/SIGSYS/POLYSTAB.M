function b = polystab(a);
%POLYSTAB Polynomial stabilization.
%	POLYSTAB(A), where A is a vector of polynomial coefficients,
%	stabilizes the polynomial with respect to the unit circle;
%	roots whose magnitudes are greater than one are reflected
%	inside the unit circle.

%	Author(s): J.N. Little,7-25-89, handles roots at zero
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/25 17:59:35 $

if length(a) == 1, b = a; return, end
v = roots(a); i = find(v~=0);
vs = 0.5*(sign(abs(v(i))-1)+1);
v(i) = (1-vs).*v(i) + vs./conj(v(i));
b = a(1)*poly(v);

% Return only real coefficients if input was real:
if ~any(imag(a))
	b = real(b);
end
