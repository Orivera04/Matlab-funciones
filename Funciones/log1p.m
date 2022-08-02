function y = log1p(x)
%LOG1P  Natural logarithm of 1+x.
%
%   LOG1P(X) = LOG(1+X) to high relative accuracy, even for small X.
%
%  See also LOG.

   % This "trick" comes from the comments in the source code for FDLIBM,
   % SunSoft's Freely Distributable Math Library, www.netlib.org/fdlibm.
   % They reference the HP-15C Advanced Functions Handbook.
   % The idea probably comes from W. Kahan, U. C. Berkeley.

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % Here is the original code.  It works well for finite, positive values, but it
   % doesn't handle NaN's and +/-Inf's and zeros correctly.

   y = x;
   u = 1 + x;
   m = (u ~= 1);
   y(m) = log(u(m)) .* (x(m) ./ (u(m) - 1));

   return

   figure(1);
   clf;
   hold on;
   x = -1e-15 : 1e-17 : 1e-15;
   y1 = log(x + 1);
   y2 = log1p(x);
   plot(x, y1, 'r-');
   plot(x, y2, 'b-');

   
   
   figure(1); clf;
   x = (eps-1 : 0.01 : 1);
   y = x;
   [X, Y] = ndgrid(x, y);
   Z = complex(X, Y);
   Z1 = log(Z + 1);
   Z2 = log1p(Z);
   W = abs(Z2 - Z1) ./ abs(Z2);
   W(W == 0) = NaN;
   mesh(X, Y, W);
   
   
   556phup
   
   
   
