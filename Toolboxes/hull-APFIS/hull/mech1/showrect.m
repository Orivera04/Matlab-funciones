function [x,y]=showrect (x,y,coords,colour)
%SHOWRECT Draws a  rectangle on the current axis.
%   SHOWRECT(BASE,HEIGHT,[X Y],COLOR) draws a rectangle of the specified
%   dimensions at the given coordinates.  Any standard color may be specified,
%   but is not required. 
%
%   See also EXPANDAXIS, SHOWCIRC, SHOWVECT, SHOWX, SHOWY, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin==3
  colour='k';
end
xo=coords(1);
yo=coords(2);
plot ([xo,xo+x,xo+x,xo,xo],[yo,yo,yo+y,yo+y,yo],colour)
