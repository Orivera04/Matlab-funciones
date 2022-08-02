function r=meet(A,B)
% meet(a,b) - return the largest common subspace of blades a and b
%
%See also gable, join.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

% Approach: this algorithm is the dual of the one for join.  See the
%  comments there.

a = A;
b = B;
if isa(a,'double')
  a = GA([a;0;0;0;0;0;0;0]);
end
if isa(b,'double')
  b = GA([b;0;0;0;0;0;0;0]);
end
a = GAZ(a);
b = GAZ(b);
if GAisa(a,'multivector') | GAisa(b,'multivector') 
    error('meet: all arguments must be blades.');
end

r = contraction(b/join(a,b), a);
