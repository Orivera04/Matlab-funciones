function C = inverse(m)
%inverse(m): Computes the inverse of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
   if GAautoscalar
      C=1/m;
   else
      C=GA([1/m;0;0;0;0;0;0;0]);
   end

