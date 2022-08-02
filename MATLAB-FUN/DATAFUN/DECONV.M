function [q,r]=deconv(b,a)
%DECONV	Deconvolution and polynomial division.
%	[Q,R] = DECONV(B,A) deconvolves vector A out of vector B.  The result
%	is returned in vector Q and the remainder in vector R such that
%	B = conv(Q,A) + R.
%
%	If A and B are vectors of polynomial coefficients, deconvolution
%	is equivalent to polynomial division.  The result of dividing B by
%	A is quotient Q and remainder R.
%
%	See also CONV.

%	J.N. Little 2-6-86
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[mb,nb] = size(b);
nb = max(mb,nb);
na = length(a);
if na > nb
    q = 0;
    r = b;
    return
end
if a(1)==0
    error('First coefficient of A must be non-zero.')
end
% Deconvolution and polynomial division are the same operations
% as a digital filter's impulse response B(z)/A(z):
q = filter(b, a, [1 zeros(1,nb-na)]);
if mb ~= 1
    q = q(:);
end
r = b - conv(q,a);
