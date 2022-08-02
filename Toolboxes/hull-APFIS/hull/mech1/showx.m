function []=showx(x,colour)
%SHOWX Draws a line across the current axis.
%   SHOWX(X,COLOR) draws a line across the current axis at the specified X in
%   the specified COLOR.  If no X is specified, the line will be drawn at X=0.
%
%   See also EXPANDAXIS, SHOWCIRC, SHOWRECT, SHOWVECT, SHOWY, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00
%
%   Modifications made to allow for plotting several horizontal lines
%   26-May-1999

if nargin<2
  colour='k';
end

if nargin<1
  x=0;
end

axisvalues=axis;
xmin=axisvalues(1);
xmax=axisvalues(2);
if ishold
  for gapli = 1 : length(x)
  	plot([xmin xmax],[x(gapli) x(gapli)],colour)
  end
else 
  hold on
  for gapli = 1 : length(x)
  	plot([xmin xmax],[x(gapli) x(gapli)],colour)
  end
  hold off
end 