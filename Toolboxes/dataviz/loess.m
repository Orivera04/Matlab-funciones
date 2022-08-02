function g = loess(x,y,newx,alpha,lambda,robustFlag)
%  curve fit using local regression
%  g = loess(x,y,newx,alpha,lambda,robustFlag)
%  apply loess curve fit -- nonparametric regression
%  x,y  data points
%  newx,g  fitted points
%  alpha  smoothing  typically 0.25 to 1.0
%  lambda  polynomial order 1 or 2
%  if robustFlag is present, use bisquare
%  for loess info, refer to Cleveland, Visualizing Data

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

robust = 0;
if nargin>5,robust=1;end

n = length(x);      %  number of data points
q = floor(alpha*n);
q = max(q,1);
q = min(q,n);       %  used for weight function width
tol = 0.003;        %  tolerance for robust approach
maxiterations = 100;

%  perform a fit for each desired x point
for ii = 1:length(newx)
   deltax = abs(newx(ii)-x);     %  distances from this new point to data
   deltaxsort = sort(deltax);     %  sorted small to large
   qthdeltax = deltaxsort(q);     % width of weight function
   arg = min(deltax/(qthdeltax*max(alpha,1)),1);
   tricube = (1-abs(arg).^3).^3;  %  weight function for x distance
   index = tricube>0;  %  select points with nonzero weights
   p = least2(x(index),y(index),lambda,tricube(index));  %  weighted fit parameters
   newg = polyval(p,newx(ii));  %  evaluate fit at this new point
   if robust
      %   for robust fitting, use bisquare
      test = 10*tol;
      niteration = 1;
      while test>tol
         oldg = newg;
         residual = y(index)-polyval(p,x(index));  %fit errors at points of interest
         weight = bisquare(residual);  %  robust weights based on residuals
         newWeight = tricube(index).*weight;  %  new overall weights
         p = least2(x(index),y(index),lambda,newWeight);  
         newg = polyval(p,newx(ii));  %  revised fit
         niteration = niteration+1;
         if niteration>maxiterations
            disp('Too many iterations')
            break
         end
         test = max(0.5*abs(newg-oldg)./(newg+oldg));
      end
   end
   g(ii) = newg;
end
