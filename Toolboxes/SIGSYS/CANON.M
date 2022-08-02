function [ab,bb,cb,db,T] = canon(a,b,c,d,Type)
%CANON	State-space to canonical form transformation.
%	[Ab,Bb,Cb,Db] = CANON(A,B,C,D,'type') transforms the continuous 
%	state-space system (A,B,C,D) into the canonical form specified by
%	`type': 'modal' transforms the state-space system into modal form 
%	                where the system eigenvalues appear on the 
%	                diagonal.  The system must be diagonalizable.
%
%	    'companion' transforms the state-space system into 
%	                companion canonical form where the characteristic
%	                polynomial appears in the right column.
%
%	With an additional left hand argument, the transformation matrix,
%	T, is returned where z = Tx:
%		[Ab,Bb,Cb,Db,T] = CANON(A,B,C,D,'type')
%
%	The modal form is useful for determining the relative controll-
%	ability of the system modes.  Note: the companion form is ill-
%	conditioned and should be avoided if possible.
%
%	See also: CTRB.

%	Clay M. Thompson  7-3-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(4,5,nargin));
error(abcdchk(a,b,c,d));

if nargin==4,	% No type specified, assume modal 
  Type = 'modal';
end
  
if ~isstr(Type), error('TYPE must be a string.'); end

% --- Determine 'type' -- Only check 1st three letters.
if all(Type(1:3)=='mod')  % Modal form
  [V,D] = eig(a);
  lambda = diag(D);
  k = 1;
  % Transformation to modal form based on eigenvectors
  while k<=length(lambda)
    if imag(lambda(k)) ~= 0.0
      T(:,k)=real(V(:,k)); T(:,k+1)=imag(V(:,k));
      k = [k+2];
    else
      T(:,k) = V(:,k);
      k = [k+1];
    end
  end
  ab = T\a*T; bb = T\b; cb = c*T; db = d;
elseif all(Type(1:3)=='com') % Companion form
  % Transformation to companion form based on controllability matrix
  if length(b)
  	T = ctrb(a,b(:,1));
	if rcond(T)<eps, 
	  error('System must be controllable from first input.'), 
	end
  else
	T = [];
  end
  ab = T\a*T; bb = T\b; cb = c*T; db = d;
else
  error('TYPE must be either ''modal'' or ''companion''.');
end

if nargout==5,  % Return inverse of T to be compatible with ss2ss
  T = inv(T);
end
