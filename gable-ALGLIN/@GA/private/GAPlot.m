function GAPlot(pts,c)
%GAPlot(pts,c): plot points.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
  if nargin == 1
    c = .5;
  end
  for i=1:length(pts)
     p = pts{i};
     x(i)=p.m(2);
     y(i)=p.m(3);
     z(i)=p.m(4);
     C(i) = c;
  end
  plot3(x,y,z,'r');
