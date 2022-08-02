function drawTrivector(tv,O,c)
%drawTrivector(tv,O,c): draw a trivector
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
  if nargin == 2
     c = 'r';
  end
  v = abs(tv.m(8));
  r = (v*3/4/pi)^(1./3.);

  [X,Y,Z]=sphere(8);
  X = r*X;
  Y = r*Y;
  Z = r*Z;
  plot3(X+O.m(2),Y+O.m(3),Z+O.m(4),c);
  hold on
  for i=1:size(X,1)
      for j=1:size(X,2)
	x(j) = X(i,j);
	y(j) = Y(i,j);
	z(j) = Z(i,j);
      end
      plot3(x+O.m(2),y+O.m(3),z+O.m(4),c);
  end
  if tv.m(8) > 0
	d = 1.2;
  else
	d = .85;
  end
  for i=1:size(X,1)
    for j=mod(i,2)+1:2:size(X,2)
      xh(1,j) = X(i,j);
      xh(2,j) = d*X(i,j);
      yh(1,j) = Y(i,j);
      yh(2,j) = d*Y(i,j);
      zh(1,j) = Z(i,j);
      zh(2,j) = d*Z(i,j);
    end
    plot3(xh+O.m(2),yh+O.m(3),zh+O.m(4),c);
  end

