function [outVector]= move (inVector, coords)
%MOVE Changes the coordintes of a vector.
%   MOVE(VECTOR,[X,Y]) moves the force vector to the specified coordinates.
%
%   See also MAG, OPP.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag ymag xcor ycor]= breakup (inVector);
newx=coords(1);
newy=coords(2);

xcor=ones(size(xcor))*newx;
ycor=ones(size(ycor))*newy;

outVector=[xmag ymag xcor ycor];
