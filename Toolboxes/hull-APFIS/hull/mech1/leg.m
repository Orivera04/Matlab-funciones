function [leglength]=leg(knownleg,hypotonous)
%LEG Finds the leg length of a right triangle.
%   LEG(L,H) will find the length of the second leg.
%
%   See also FINDANGLE, HYP.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00
  
leglength=sqrt(hypotonous.^2-knownleg.^2);
