function y = trimmedmean(x,trimFraction)
%  Calculate mean without top and bottom trimFraction of data
%  y = trimmedmean(x,trimFraction)
%  If x is a matrix, it is processed columnwise
%  The default trimFraction is 0.1

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  work with columns
if size(x,1)==1
   x = x(:);
end

if nargin<2
   trimFraction = 0.1;
else
   %  cope with trimFraction in percent
   if trimFraction>=1
      trimFraction = trimFraction/10;
   end
end

%  order each column
x = sort(x);
n = size(x,1);
%  discard from bottom and top
x(round((1-trimFraction)*n):end,:) = [];
x(1:round(trimFraction*n),:) = [];

y = mean(x);