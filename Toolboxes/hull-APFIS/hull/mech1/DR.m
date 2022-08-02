function [radians]=DR(degrees)
%DR Changes a matrix of degree measure to a matrix of radian measure.
%   DR(X) is the radian equivalent of the elements of X.
%
%   See also RD.
%

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

radians=degrees*pi/180;
