function [wnout,z] = damp(a)
% DAMP	Natural frequency and damping factor for continuous systems.
%	[Wn,Z] = DAMP(A) returns vectors Wn and Z containing the
%	natural frequencies and damping factors of A.   The variable A
%	can be in one of several formats:
%
%		1) If A is square, it is assumed to be the state-space
%		   "A" matrix.
%		2) If A is a row vector, it is assumed to be a vector of
%		   the polynomial coefficients from a transfer function.
%		3) If A is a column vector, it is assumed to contain
%		   root locations.
%
%	When invoked without left hand arguments DAMP prints the 
%	eigenvalues with their natural frequency and damping factor in a
%	tabular format on the screen.
%
%	See also: EIG and DDAMP.

% 	J.N. Little 10-11-85
%	Revised 3-12-87 JNL
%	Revised 7-23-90 Clay M. Thompson
%	Copyright (c) 1986-93 by the MathWorks, Inc.

[m,n] = size(a);
if (m == n)
	r = esort(eig(a));
elseif (m == 1)
	r = esort(roots(a));
elseif (n == 1)
	r = a;
else
	error('Must be a vector or a square matrix.');
end
wn = abs(r);
z = -cos(atan2(imag(r),real(r)));

if nargout==0,		% Print results on the screen.
  disp('')
  disp('   Eigenvalue        Damping        Freq. (rad/sec)')
  disp('')
  disp([r,z,wn])

  return % Suppress output
end
wnout = wn; 
