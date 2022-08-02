function [z,p,k] = buttap(n)
%BUTTAP	Butterworth analog lowpass filter prototype.
%	[Z,P,K] = BUTTAP(N) returns the zeros, poles, and gain
%	for an N-th order normalized prototype Butterworth analog
%	lowpass filter.  The resulting filter has N poles around
%	the unit circle in the left half plane, and no zeros.
%
%	See also BUTTER, CHEB1AP, and CHEB2AP.

%	Author(s): J.N. Little and J.O. Smith, 1-14-87
%		   L. Shure, 1-13-88, revised
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:58:42 $

% Poles are on the unit circle in the left-half plane.
z = [];
p = exp(sqrt(-1)*(pi*(1:2:2*n-1)/(2*n) + pi/2)).';
k = real(prod(-p));

