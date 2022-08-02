function slplotr(location,residual,alpha,lambda)
%  Make spread location plot for residuals with optional loess curve
%  slplotr(location,residual,alpha,lambda)
%  plots (location,residual) points
%  alpha and lambda are loess parameters

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  transform residuals to reduce skew
residual = sqrt(abs(residual));
if nargin>3
   newx = linspace(min(location),max(location),50);
   newy = loess(location,residual,newx,alpha,lambda);
   plot(location,residual,'o',newx,newy,'g-')
else
   plot(location,residual,'o')
end
