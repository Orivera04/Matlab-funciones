function C = contraction(m,n)
%contraction(m,n): Computes the contraction of two multivectors.
%Takes two arguments and gives the contraction of the first
%onto the second.
% contraction(m,n) = sum_r,s grade(grade(m,r)*grade(n,s), s-r) r,s>=0
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
  if isa(m,'GA')
      if isa(n,'GA')
         T = GAcontraction(m,n);
         if GAautoscalar&isascalar(T)
            C = T.m(1);
         else
            C = T;
         end
      elseif GAautoscalar
         C = m.m(1)*n;
      else
         C = GA([m.m(1)*n;0;0;0;0;0;0;0]);
      end
  else
%Since m is not a GA then n must be a GA
      if GAautoscalar&isascalar(n)
         C = n.m(1)*m;
      else
         C = GA(n.m*m);
      end
  end
     
