function y = trimmedstd(x,trimFraction)
%  Calculate standard deviation without top and bottom trimFraction of data
%  The result is scaled so that trimmedstd and std produce 
%  approximately the same answer for a normal population.
%  y = trimmedstd(x,trimFraction)
%  If x is a matrix, it is processed columnwise
%  The default trimFraction is 0.1

% Copyright (c) 1998-2000 by Datatool
% $Revision: 1.10 $

%  work with columns
if size(x,1)==1
   x = x(:);
end

if nargin<2
   trimFraction = 0.1;
else
   if trimFraction>=1
      trimFraction = trimFraction/10;
   end
end

if trimFraction>0.3
   warning('Scaling is poor for trimFraction > 0.3')
end

%  order each column
x = sort(x);
n = size(x,1);
%  discard from bottom and top
x(round((1-trimFraction)*n):end,:) = [];
x(1:round(trimFraction*n),:) = [];

y = std(x);

%  Apply scale factor.
p = [62.7733  -11.4996    5.5350    1.0];
factor = polyval(p,trimFraction);
y = y*factor;
