function T = bilinear(m,n)
%bilinear(m,n): Computes the bilinear form of two multivectors.
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
         T = GAbilinear(m,n);
      else
         T = m.m(1)*n;
      end
  else
      if isa(n,'GA')
         T = n.m(1)*m;
      else
         T = m*n;
      end
  end
     
