function [num,den] = zp2tf(z,p,k)
%ZP2TF	Zero-pole to transfer function conversion.
%	[NUM,DEN] = ZP2TF(Z,P,K)  forms the transfer function:
%
%	                NUM(s)
%	        H(s) = -------- 
%	                DEN(s)
%
%	given a set of zero locations in vector Z, a set of pole locations
%	in vector P, and a gain in scalar K.  Vectors NUM and DEN are 
%	returned with numerator and denominator coefficients in descending
%	powers of s.  
%
%	See also: TF2ZP.

% 	J.N. Little 7-17-85
%	Revised 6-27-88
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/25 17:56:02 $

%	Note: the following will not work if p or z have elements not
%	in complex pairs.

den = real(poly(p(:)));
[md,nd] = size(den);
k = k(:);
[mk,nk] = size(k);
if isempty(z), num = [zeros(mk,nd-1),k]; return; end
[m,n] = size(z);
if mk ~= n
	if m == 1
		error('Z and P must be column vectors.');
	end
	error('K must have as many elements as Z has columns.');
end
for j=1:n
	zj = z(:,j);
	pj = real(poly(zj)*k(j));
	num(j,:) = [zeros(1,nd-length(pj)) pj];
end
