function b = DrawBivector(A,B,c)
% DrawBivector(A,B,c) : draw the bivector A^B.  
%  A and B must be vectors.  c is an optional color argument.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.


if nargin == 2
    c = 'y';
end
A = GAZ(A);
B = GAZ(B);
if ~GAisa(A,'vector') | ~GAisa(B,'vector')
    A
    B
    error('DrawBivector: A and B must both be vectors.');
end
% DrawBivector: draw the parallelogram bounded by A,B.
X = [0 A.m(2) A.m(2)+B.m(2) B.m(2)];
Y = [0 A.m(3) A.m(3)+B.m(3) B.m(3)];
Z = [0 A.m(4) A.m(4)+B.m(4) B.m(4)];
biarrow(B,A,'g');
patch(X,Y,Z,c);
draw(A);
b = A^B;
