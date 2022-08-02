function GAMesh(pts,c)
%GAMesh(pts,c): Plot a mesh of GA vectors in color c (optional)
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
  M = size(pts,1);
  N = size(pts,2);
  for i=1:M
      for j=1:N
	  p = pts{i,j};
	  x(i,j) = p.m(2);
	  y(i,j) = p.m(3);
	  z(i,j) = p.m(4);
	  C(i,j) = c;
      end
  end
  mesh(x,y,z,C);
