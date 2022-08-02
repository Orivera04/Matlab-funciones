function []=expandaxis(perleft, perright, perdown, perup)
%EXPANDAXIS Extends the current axis in any or all directions.
%   EXPANDAXIS(left, right, down, up) Each of the direction will be expanded
%   by the specified percent.  For example if Left were specified as 30 then
%   the upper bound of the axis would be increased by 30% of the vertical
%   distance across the horizontal axis.
%
%   If no argument is given, the routine will default to 10% in the
%   unspecified directions.
%
%   See also SHOWCIRC, SHOWRECT, SHOWVECT, SHOWX, SHOWY, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin<4
  perup=10;
end

if nargin<3
  perdown=10;
end

if nargin<2
  perright=10;
end

if nargin<1
  perleft=10;
end

edges=axis;
left=edges(1);
right=edges(2);
bottom=edges(3);
top=edges(4);

hordist=right-left;
verdist=top-bottom;

newleft=left-(hordist*perleft/100);
newright=right+(hordist*perright/100);
newbottom=bottom-(verdist*perdown/100);
newtop=top+(verdist*perup/100);

axis([newleft newright newbottom newtop]);
