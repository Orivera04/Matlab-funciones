function [p, S] = polyfit2b(x,y,z,n,m)
%  POLYFIT2B finds the polynomial coefficients of a 
%  function of 2 variables x and y of degrees n and m, respectively,
%  that fit	the data in z in a robust least-squares sense, using bisquare weights on residuals.
%  x,y and z can be vectors or matrices of the same size.
% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.
%
%  [p, S] = polyfit2b(x,y,z,n,m)
%
%  if n = 3 and m = 1,
%  the coefficents of the output p    
%  matrix are arranged as shown:
%
%      p31 p30 
%      p21 p20 
%      p11 p10 
%      p01 p00
%
% The indices on the elements of p correspond to the 
% order of x and y associated with that element.
%
% For a solution to exist, the number of ordered 
% triples [x,y,z] must equal or exceed (n+1)*(m+1).
% Note that m or n may be zero.
%
% To evaluate the resulting polynominal function,
% use POLYVAL2D.

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

if any((size(x) ~= size(y)) | (size(z) ~= size(y)))
	error('X, Y and Z must be the same size')
end

x = x(:); y = y(:); z= z(:);  % Switches vectors or matrices to columns

if length(x) < (n+1)*(m+1)
 error('Number of points must equal or exceed order of polynomial function.')
end


tol = 0.001;        %  tolerance for robust approach
maxiterations = 100;

%  initial estimate with uniform weights
weight = ones(size(x));
[p, S] = polyfit2w(x,y,z,weight,n,m)
newz = polyval2d(p,x,y);

test = 10*tol;
niteration = 1;

%  iterate to solution
   while test>tol
      oldz = newz;
      residual = z-newz;
      weight = bisquare(residual);
      p = polyfit2w(x,y,z,weight,n,m);
      newz = polyval2d(p,x,y);  %  revised fit
      niteration = niteration+1;
         if niteration>maxiterations
            disp('Too many iterations')
            break
         end
      test = max(0.5*abs(newz-oldz)./(newz+oldz));
   end
