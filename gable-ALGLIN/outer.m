function C = outer(M,N)
%outer(M,N): Computes the outer product of two multivectors.
%
%See also gable, GA/mpower.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%Equivalent to the regular product of reals.
   if GAautoscalar
      C=M*N;
   else
      C=GA([M*N;0;0;0;0;0;0;0]);
   end    
