function g = loess2(x,y,z,newx,newy,alpha,lambda,robustFlag)
%  surface fit using local regression
%  g = loess2(x,y,z,newx,newy,alpha,lambda,robustFlag)
%  apply loess surface fit -- nonparametric regression
%  x,y,z  data points
%  newx,newy,g  fitted points
%  alpha  smoothing  typically 0.25 to 1.0
%  lambda  polynomial order 1 or 2
%  if robustFlag is present, use bisquare
%  refer to Cleveland, Visualizing Data
%  Note: If x and y are not on the same scale, they should be standardized first.

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

if any((size(x) ~= size(y)) | (size(z) ~= size(y)))
	error('x,y,z must be the same size')
end
if any((size(newx) ~= size(newy)))
	error('newx and newy must be the same size')
end

sizeofnewx = size(newx);
newx = newx(:); newy = newy(:);
x = x(:); y = y(:); z = z(:);

robust = 0;
if nargin>7,robust=1;end

n = size(x,1)*size(x,2);      %  number of data points
q = floor(alpha*n);
q = max(q,1);
q = min(q,n);       %  used for weight function width
tol = 0.003;        %  tolerance for robust approach
maxiterations = 50;  % for bisquare

%  perform a fit for each newx,newy point
for ii = 1:length(newx)
   deltax = sqrt((newx(ii)-x).^2+(newy(ii)-y).^2);     %  distances from this new point to data
   deltaxsort = sort(deltax);     %  sorted small to large
   qthdeltax = deltaxsort(n)*sqrt(alpha);     % width of weight function
   arg = min(deltax/(qthdeltax*max(alpha,1)),1);
   tricube = (1-abs(arg).^3).^3;  %  weight function for x distance
   index = tricube>0;  %  select points with nonzero weights
   p = polyfit2w(x(index),y(index),z(index),tricube(index),lambda,lambda);  %  weighted fit parameters
   newg = polyval2d(p,newx(ii),newy(ii));  %  evaluate fit at this new point
   if robust
      %   for robust fitting, use bisquare
      test = 10*tol;
      niteration = 1;
      while test>tol
         oldg = newg;
         residual = z(index)-polyval2d(p,x(index),y(index));  %fit errors at points of interest
         weight = bisquare(residual);  %  robust weights based on residuals
%         tricube(index) = tricube(index).*weight;  %  new overall weights
%         p = least2(x(index),y(index),lambda,tricube(index));  
         newWeight = tricube(index).*weight;  %  new overall weights
         p = polyfit2w(x(index),y(index),z(index),newWeight,lambda,lambda);  
         newg = polyval2d(p,newx(ii),newy(ii));  %  revised fit
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

g = reshape(g,sizeofnewx);