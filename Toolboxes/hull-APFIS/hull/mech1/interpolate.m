function [outvalue]=interpolate(x,y,invalue)
%INTERPOLATE Linear interpolation for a given value.
%
%   INTERPOLATE(X,Y,XVALUE) With a vector of X and Y values that correspond to
%   one another, the linear interpolation of the YVALUE that corresponds to the
%   given XVALUE will be found.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if invalue>max(x) | invalue<min(x)
  disp('That value is not in the range that can be interpolated.')
end

biggerindex=min(find(x>=invalue));
smallerindex=max(find(x<=invalue));

X2=x(biggerindex);
Y2=y(biggerindex);

X1=x(smallerindex);
Y1=y(smallerindex);

if X2==X1
  outvalue=Y1;
else
  outvalue=((invalue-X1)/(X2-X1))*(Y2-Y1)+Y1;
end
