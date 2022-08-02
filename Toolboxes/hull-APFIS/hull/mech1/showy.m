function []=showx(y,colour)
%SHOWY Draws a line across the current axis.
%   SHOWY(X,COLOR) draws a line across the current axis at the specified Y in
%   the specified COLOR.  If no Y is specified, the line will be drawn at Y=0.
%
%   See also EXPANDAXIS, SHOWCIRC, SHOWRECT, SHOWVECT, SHOWX, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00
%
%   Modifications made to allow for plotting several vertical lines
%   26-May-1999

if nargin<2
  colour='k';
end

if nargin<1
  y=0;
end

axisvalues=axis;
ymin=axisvalues(3);
ymax=axisvalues(4);
if ishold
  for gapli = 1 : length(y)
  	plot([y(gapli) y(gapli)],[ymin ymax],colour)
  end
else 
  hold on
  for gapli = 1 : length(y)
  	plot([y(gapli) y(gapli)],[ymin ymax],colour)
  end
  hold off
end