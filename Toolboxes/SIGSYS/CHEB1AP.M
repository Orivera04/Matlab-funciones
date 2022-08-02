function [z,p,k] = cheb1ap(n, rp)
%CHEB1AP	Chebyshev type I analog lowpass filter prototype.
%	[Z,P,K] = CHEB1AP(N,Rp) returns the zeros, poles, and gain
%	of an N-th order normalized prototype type I Chebyshev analog
%	lowpass filter with Rp decibels of ripple in the passband.
%	Type I Chebyshev filters are maximally flat in the stopband.
%
%	See also CHEBY1, CHEB1ORD, BUTTAP, CHEB2AP and ELLIPAP.

%	Author(s): L. Shure, 1-13-88
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:58:45 $

j = sqrt(-1);
epsilon = sqrt(10^(.1*rp)-1);
mu = asinh(1/epsilon)/n;
p = exp(j*(pi*(1:2:2*n-1)/(2*n) + pi/2)).';
p = sinh(mu)*real(p) + j*cosh(mu)*imag(p);
z = [];
k = real(prod(-p));
if ~rem(n,2)	% n is even so patch k
	k = k/sqrt((1 + epsilon^2));
end
