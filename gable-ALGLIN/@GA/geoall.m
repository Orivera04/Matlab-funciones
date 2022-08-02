function r = geoall(A,B)
%geoall(A,B): Compute the geometric relationships between blades A and B
% Return a structure with the following fields
%   obj1 = A
%   obj2 = B
%   comp = orthogonal complement of A in B
%   proj = projection of A onto B
%   rej  = rejection of A by B
%   meet = meet (i.e. intersection) of A and B
%   join = join (i.e. union) of A and B
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
       if grade(GA(A)) == -1 & grade(GA(B)) == -1
          error('A and B should be pure blades')
       end
       r.obj1 = A;
       r.obj2 = B;
       r.comp = contraction(A,B);  
       r.proj = r.comp/B;
       r.rej = A - r.proj;
       r.meet = meet(A,B);
       r.join = join(A,B);
