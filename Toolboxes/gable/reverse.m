function C = reverse(A)
%reverse(A): returns the reverse of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%Equivalent to doing nothing at all.
     if GAautoscalar
	C=A;
     else
	C=GA([A;0;0;0;0;0;0;0]);
     end
