function y = standardize(x)
%  use trimmed sample standard deviation to normalize data spread
%  y = standardize(x)
%  if x is a matrix, it is processed columnwise
%  This suppresses the effects of outliers

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

tssd = trimmedstd(x);

[r,c] = size(x);
if any(size(x))==1
   y = x/tssd;
else
   y = x./repmat(tssd,r,1);
end
