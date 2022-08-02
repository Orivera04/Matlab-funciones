function p = least2b(x,y,n)
%  fit polynomial to data using bisquare weights
%  p = least2b(x,y,n)
%  x,y  data points
%  n  polynomial degree
%  for bisquare info, refer to Cleveland, Visualizing Data

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

tol = 0.001;        %  tolerance for robust approach
maxiterations = 100;

%  initial estimate with uniform weights
p = polyfit(x,y,n);
newy = polyval(p,x);

test = 10*tol;
niteration = 1;

%  iterate to solution
   while test>tol
      oldy = newy;
      residual = y-newy;
      weight = bisquare(residual);
      p = least2(x,y,n,weight);
      newy = polyval(p,x);  %  revised fit
      niteration = niteration+1;
         if niteration>maxiterations
            disp('Too many iterations')
            break
         end
      test = max(0.5*abs(newy-oldy)./(newy+oldy));
   end
      
