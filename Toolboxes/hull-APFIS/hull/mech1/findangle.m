function [angles]=findangle (a,b,c);
%FINDANGLE Finds unknown angles of a triangle.
%   FINDANGLE(A,B,C) Given the lengths of the three sides of a triange, finds
%   the angles that correspond to that triangle.  Returns angles in an order
%   such that each corresponds to the length of it's opposing side.
%
%   See also HYP, LEG.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

angles(1)=acos((a^2-b^2-c^2)/(-2*b*c));
angles(2)=acos((b^2-a^2-c^2)/(-2*a*c));
angles(3)=acos((c^2-a^2-b^2)/(-2*a*b));
