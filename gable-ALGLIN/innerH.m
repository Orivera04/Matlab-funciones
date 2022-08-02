function C = innerH(M,N)
%innerH(M,N): Computes the Hestenes inner product between two multivectors.
% innerH(m,n) = sum_r,s grade(grade(m,r)*grade(n,s),|r-s|) for r,s>=0
%                unless grade(m) or grade(n) is zero, 
%                in which case inner(m,n)=0
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

%Computes the inner product of two scalars.
% Equivalent to getting a zero.
   if GAautoscalar
      C=0;
   else
      C=GA([0;0;0;0;0;0;0;0]);
   end    

