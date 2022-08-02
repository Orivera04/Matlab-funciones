function [outVector]=opp(inVector)
%OPP Returns the equal but opposite vector
%   OPP(VECTOR) returns the vector acting in the opposite direction to the
%   input vector.
%
%   See also MAG, MOVE.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag ymag xcor ycor]=breakup(inVector);

outVector=[-xmag -ymag xcor ycor];
