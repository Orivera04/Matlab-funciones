function [magout,wn,z] = ddamp(a,Ts)
%DDAMP	Natural frequency and damping factor for discrete systems.
%	[MAG,Wn,Z] = DDAMP(A,Ts) returns vectors MAG, Wn and Z containing
%	the z-plane magnitude, and the equivalent s-plane natural 
%	frequency and damping factors of A.  Ts is the sample time.  The
%	variable A can be in one of several formats:
%		1) If A is square, it is assumed to be the state-space
%		   "A" matrix.
%		2) If A is a row vector, it is assumed to be a vector of
%		   the polynomial coefficients from a transfer function.
%		3) If A is a column vector, it is assumed to contain
%		   root locations.
%
%	Without the sample time, DDAMP(A) returns the magnitude only.  
%	When invoked without left hand arguments DDAMP prints the 
%	eigenvalues with their magnitude, natural frequency and damping
%	factor in a tabular format on the screen.
%
%	For a discrete system eigenvalue, lambda, the equivalent s-plane
%	natural frequency and damping ratio are
%
%		Wn = abs(log(lamba))/Ts    Z = -cos(angle(log(lamba)))
%
%	See also: EIG and DAMP.

%	Clay M. Thompson  7-23-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(1,2,nargin));

[m,n] = size(a);
if (m == n)
	r = dsort(eig(a));
elseif (m == 1)
	r = dsort(roots(a));
elseif (n == 1)
	r = a;
else
	error('Must be a vector or a square matrix.');
end
mag = abs(r);

if nargin==2,	% If sample time is given solve for equivalent s-plane roots
  s = log(r)/Ts;
  wn = abs(s);
  z = -cos(atan2(imag(s),real(s)));
else
  s = [];
  wn = [];
  z = [];
end

if nargout==0,		% Print results on the screen.
  disp('')
  if nargin==2,
    disp('   Eigenvalue        Magnitude      Equiv. Damping   Equiv. Freq. (rad/sec)')
  else
    disp('   Eigenvalue        Magnitude')
  end
  disp('')
  disp([r,mag,z,wn])

  return % Suppress output
end
magout = mag; 
