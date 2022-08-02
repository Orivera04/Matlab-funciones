function C = contraction(M,N)
%contraction(M,N): Computes the contraction of two multivectors.
% Takes two arguments and gives the contraction of the first
% onto the second.  
%
% contraction(m,n) = sum_r,s grade(grade(m,r)*grade(n,s), s-r) r,s>=0
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%Computes the contraction of two scalars.
% Equivalent to the regular product of reals.
   if GAautoscalar
      C=M*N;
   else
      C=GA([M*N;0;0;0;0;0;0;0]);
   end
     
