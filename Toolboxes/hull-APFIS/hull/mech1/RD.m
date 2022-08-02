function [degrees]=RD(radians)
%RD Changes a matrix of radian measure to a matrix of degree measure.
%
%   RD(X) is the radian equivalent of the elements of X.
%
%   See also DR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

degrees=radians*180/pi;
