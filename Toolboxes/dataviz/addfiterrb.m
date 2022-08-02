function err = addfiterrb(x,data)
% calculate additive fit error using bisquare weights
%  err = addfiterrb(x,data)
%  data  data array
%  x  [column_coefficients row_coefficients mean] 

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

[r c] = size(data);
mu = x(end);       %  estimated mean

xr = x(1:r);       %  estimated column coefficients
xc = x(r+1:end-1); %  estimated row coefficients
estimate = repmat(xr(:),1,c)+repmat(xc(:)',r,1)+mu*ones(size(data));
difference = estimate-data;
weight = bisquare(difference(:));
weight = reshape(weight,r,c);
err = sum(sum(weight.*difference.^2));
