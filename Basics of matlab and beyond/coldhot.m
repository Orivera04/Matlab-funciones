function [cm] = coldhot(m)
%
% COLDHOT   Shades of purple to blue to white to red to yellow colormap.
%  COLDHOT(M) returns an M-by-3 matrix containing a
%  "coldhot colormap"
%
%  See also HSV, COLORMAP, RGBPLOT.

%
% Copyright  Jody Klymak, 1998 jklymak@apl.washington.edu
% Do not distribute w/o this copyright notice.
%

if nargin<1
 [m,n] = size(colormap);
end;

hs=flipud(hsv(ceil(2.91*m*1/3)));
ch=brighten(coldhot(ceil(m*1/3)),0.5);
aut=brighten(autumn(ceil(m*1/3)),0.5);
mm=m*1/3;
cm = [hs(1:mm,:); ch; aut(1:mm,:)];

%cm = flipud([r,g,b]);
% darken so that transparencies look good.
%cm = brighten(cm,-0.3);


