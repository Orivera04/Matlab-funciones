function plot3(A,c)
% plot3(A,c): plot a 3d line connecting end points of A in color c
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

if nargin == 1 
     c = 'b';
end
for i=1:length(A)
     p = A{i};
     x(i) = p.m(1);
     y(i) = p.m(2);
     z(i) = p.m(3);
end
plot3(x,y,z,c);
