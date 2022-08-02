function [x,y]=showcirc (radius,coords,colour)
%SHOWCIRC Draws a circle on the current axis.
%   SHOWCIRC(RADIUS,[X Y],COLOR) draws a circle of the specified RADIUS at the 
%   given coordinates. Any standard color may be specified, but is not required.
%
%   See also EXPANDAXIS, SHOWRECT, SHOWVECT, SHOWX, SHOWY, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin==2
  colour='k';
end

angle =[0: DR(1): DR(360)];
x=coords(1) + radius*cos(angle);
y=coords(2) + radius*sin(angle);
plot (x,y,colour)
