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
     T=GA([A.m(1);A.m(2);A.m(3);A.m(4);-A.m(5);-A.m(6);-A.m(7);-A.m(8)]);
     if GAautoscalar&isascalar(T)
	C=T.m(1);
     else
	C=T;
     end
