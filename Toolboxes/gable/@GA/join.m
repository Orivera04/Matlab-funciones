function r=join(A,B)
% join(a,b): return the smallest common superspace of blades a and b
%
%See also gable, meet.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

% Approach: We will exploit the structure of our 3D space.
%  In particular, the wedge product will often (but not) always
%  compute what we want.  When it fails, the dual product may
%  compute what we want.  Together, the two of them only fail
%  when both objects are vectors or bivectors, and the join
%  is degenerate.  In such cases, the join will either be the
%  bivector, or if both arguments are vectors, then its the
%  vector.
% Note: this approach works because except in degenerate cases,
%  if a and b have a common subspace, then dual(a) and dual(b) 
%  do not have a common subspace.  Thus, we can not easily
%  generalize this approach to higher dimensional spaces.

a = GAZ(A);
b = GAZ(B);
if GAisa(a,'multivector') | GAisa(b,'multivector')
    error('join: both arguments must be blades.');
end
p = GAZ(a^b);
if p ~= 0
  r = p;
else
  m = GAZ(contraction(dual(b),a));
  if m ~= 0
    r = norm(m)*(a/m)^b;
  else
    if GAisa(a,'bivector')
      r = norm(b)*a;	
    else
      r = norm(a)*b;	
    end
  end
end
