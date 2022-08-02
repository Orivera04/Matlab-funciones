function C = gexp(A)
%gexp(A): Computes the geometric product exponential of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
      T=GAgexp(A);
      if GAautoscalar&isascalar(T)
	 C=T.m(1);
      else
	 C=T;
      end
