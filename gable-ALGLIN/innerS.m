function C = innerS(M,N)
%innerS(M,N): Computes the inner product between two multivectors.
% innerS(m,n) = sum_r,s grade(grade(m,r)*grade(n,s), |r-s|) r,s >=0
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%Computes the inner product of two scalars.
% Equivalent to multiplying the two scalars
   if GAautoscalar
      C=M*N;
   else
      C=GA([M*N;0;0;0;0;0;0;0]);
   end    

