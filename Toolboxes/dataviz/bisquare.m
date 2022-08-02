function weight = bisquare(residual)
%  calculate robustness weights using bisquare technique
%  weight = bisquare(residual)
%  refer to Cleveland, Visualizing Data

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  use median absolute deviation of residuals as scale factor
s = median(abs(residual));
%  make 0<= scaled residuals <=1
u = min(abs(residual/(6*s)),1);
%  use bisquare function
weight = (1-u.^2).^2;
