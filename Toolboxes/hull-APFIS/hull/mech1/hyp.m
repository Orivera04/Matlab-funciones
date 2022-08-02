function [hypotenuse]=hyp(x,y)
%HYP Finds the hypotenous of a right triangle.
%
%   HYP(X,Y) Finds the hypotenuse of a right triangle with legs X and Y
%
%   See also FINDANGLE, LEG.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00
   
hypotenuse=sqrt(x.^2+y.^2);
