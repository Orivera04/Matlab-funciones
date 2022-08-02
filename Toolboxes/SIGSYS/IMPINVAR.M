function [bz,az] = impinvar(b,a,Fs)
%IMPINVAR  Impulse invariance method for analog to digital filter conversion.
%	[BZ,AZ] = IMPINVAR(B,A,Fs) creates a digital filter with numerator
%	and denominator coefficients BZ and AZ respectively whose impulse 
%	response is equal to the impulse response of the analog filter with 
%	coefficients B and A sampled at a frequency of Fs Hertz.
%
%	If you don't specify Fs, it defaults to 1 Hz.
%
%	See also BILINEAR.

%	Author(s): J. McClellan, Georgia Tech, EE, DSP, 1990
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/25 17:59:17 $

error(nargchk(2,3,nargin))

if nargin<3, Fs = 1; end

[M,N] = size(a);
if M>1 & N>1
   error(' A must be vector')
end
[M,N] = size(b);
if M>1 & N>1
   error(' B must be vector')
end

b = b(:);
a = a(:);

[ r, p, k ] = residue( b, a );

[ bz, az ] = residuez( r, exp(p/Fs), k );

