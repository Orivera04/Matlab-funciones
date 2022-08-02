function [X,Z] = linsolve(A,B)
%LINSOLVE Solution of simultaneous linear equations.
%	X = LINSOLVE(A,B), for a square matrix A, solve A*X = B.
%	A warning message is printed if the matrix is singular.
%
%	[X,Z] = LINSOLVE(A,B) also computes Z, a basis for the null
%	space of A.  The general solution to the linear system is
%	    X + Z*p
%	where p is a vector (or matrix) of free parameters.
%
%	See also \ (backslash), NULLSPACE.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:01 $

if prod(symsize(A)) == 1
   X = A\B;
   Z = nullspace(A);
   return
end

X = maple('linsolve',A,B,'''Rank''','''nullparm''');
nullity = size(A,1) - numeric(maple('Rank'));

% Solution might not exist.

if isempty(X)
   X = NaN;
   disp(' ');
   disp('Warning: Matrix is rank deficient; solution does not exist.')

% Set any free parameters, nullparm(k), to zero.

elseif nullity > 0
   for k = 1:nullity
      X = subs(X,0,['nullparm(' int2str(k) ')']);
   end
   disp(' ');
   disp('Warning: Matrix is rank deficient; solution is not unique.')
end

if nargout == 2
   Z = nullspace(A);
end
