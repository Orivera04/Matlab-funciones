function [V,J] = jordan(A)
%JORDAN	Jordan Canonical Form.
%	JORDAN(A) computes the Jordan Canonical/Normal Form of the matrix A.
%	The matrix must be known exactly, so its elements must be integers,
%	or ratios of small integers.  Any errors in the input matrix may
%	completely change its JCF.
%
%	[V,J] = JORDAN(A) also computes the similarity transformation, V, so
%	that V\A*V = J.  The columns of V are the generalized eigenvectors.
%
%	Example:
%	    [V,J] = jordan(gallery(5))
%
%	See also EIGENSYS, CHARPOLY.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:36:59 $

% Without vectors.
if nargout < 2
   if prod(symsize(A)) == 1
      V = A;
   else
      V = maple('jordan',A);
   end

% With vectors.
else
   if prod(symsize(A)) == 1
      J = A;
      V = 1;
   else
      J = maple('jordan',A,'''V''');
      V = inverse(maple('print','V'));
   end
end
