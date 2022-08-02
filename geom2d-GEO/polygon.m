function polygon(Poly, BV, O, c)
% polygon(Poly,BV,O,c): draw a polygon
%  Poly: a polygon struct
%  BV: bivector plane in which to draw
%  O: an offset from the origin
%  c: the color of the polygon
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

N = dual(BV);
lA = abs(norm(N));

if abs(N.m(4)) < lA*.9
   p1 = grade((e3^N)*inverse(N),1);
else
   p1 = grade((e2^N)*inverse(N),1);
end
hold on
p2 = dual(p1^N);

p1 = (sqrt(lA/Poly.A)/sqrt(double(inner(p1,p1))))*p1;
p2 = (sqrt(lA/Poly.A)/sqrt(double(inner(p2,p2))))*p2;

% Cell array version
for i=1:length(Poly.X)
    pts{i} = (Poly.X(i)-Poly.CX)*p1 + (Poly.Y(i)-Poly.CY)*p2 + O;
end

% Convert character color to RGB triple
if isa(c,'char')
   if strncmp(c,'r',1)
      c = [1 0 0];
   elseif strncmp(c,'g',1)
      c = [0 1 0];
   elseif strncmp(c,'b',1)
      c = [0 0 1];
   elseif strncmp(c,'c',1)
      c = [0 1 1];
   elseif strncmp(c,'m',1)
      c = [1 0 1];
   elseif strncmp(c,'y',1)
      c = [1 1 0];
   elseif strncmp(c,'w',1)
      c = [1 1 1];
   end
end
GAPatch(pts,c);
