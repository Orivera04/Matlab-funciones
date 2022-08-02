function t = DrawTrivector(A,B,C)
% DrawTrivector(A,B,C): draw the parallelepiped bounded by A,B,C.  
%  First call DrawBivector(A,B) and then add the rest of the arrows.
%DrawBivector(A,B);
%
%See also gable, DrawBivector.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

draw(A,'b');
draw(B,'g');
draw(C,'m');
X = [C.m(2) C.m(2)+A.m(2) C.m(2)+A.m(2)+B.m(2) C.m(2)+B.m(2) C.m(2)];
Y = [C.m(3) C.m(3)+A.m(3) C.m(3)+A.m(3)+B.m(3) C.m(3)+B.m(3) C.m(3)];
Z = [C.m(4) C.m(4)+A.m(4) C.m(4)+A.m(4)+B.m(4) C.m(4)+B.m(4) C.m(4)];
plot3(X,Y,Z,'r');
X = [C.m(2)+A.m(2) A.m(2) A.m(2)+B.m(2) C.m(2)+A.m(2)+B.m(2)];
Y = [C.m(3)+A.m(3) A.m(3) A.m(3)+B.m(3) C.m(3)+A.m(3)+B.m(3)];
Z = [C.m(4)+A.m(4) A.m(4) A.m(4)+B.m(4) C.m(4)+A.m(4)+B.m(4)];
plot3(X,Y,Z,'r');
X = [A.m(2)+B.m(2)  B.m(2) C.m(2)+B.m(2)]';
Y = [A.m(3)+B.m(3) B.m(3) C.m(3)+B.m(3)]';
Z = [A.m(4)+B.m(4) B.m(4) C.m(4)+B.m(4)]';
plot3(X,Y,Z,'r');
axis equal;
t = A^B^C;
