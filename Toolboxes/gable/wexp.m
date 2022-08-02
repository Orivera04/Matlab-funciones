function C = wexp(A)
%wexp(A): Gives the wedge exponential of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
      T=exp(A);
      if GAautoscalar
	 C=T;
      else
	 C=GA([T;0;0;0;0;0;0;0]);
      end
