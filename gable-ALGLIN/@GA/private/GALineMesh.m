function GALineMesh(pts,c)
%GALineMesh(pts,c): Plot a grid of GA vectors in color c (optional)
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
  M = size(pts,1);
  N = size(pts,2);
  for i=1:M
      for j=1:N
	  p = pts{i,j};
	  x(j) = p.m(2);
	  y(j) = p.m(3);
	  z(j) = p.m(4);
      end
      plot3(x,y,z,c);
  end
  for j=1:N
      for i=1:M
	  p = pts{i,j};
	  x(i) = p.m(2);
	  y(i) = p.m(3);
	  z(i) = p.m(4);
      end
      plot3(x,y,z,c);
  end
  
