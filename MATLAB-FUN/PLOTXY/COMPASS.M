function [hc,hb] = compass(x,y,s)
%COMPASS Compass plot.
%	COMPASS(Z) draws a graph that displays the angle and magnitude
%	of the complex elements of Z as arrows emanating from the origin.
%
%	COMPASS(X,Y) is equivalent to COMPASS(X+i*Y).  It displays the
%	compass plot for the angles and magnitudes of the elements of
%	matrices X and Y.
%
%	COMPASS(Z,'S') and COMPASS(X,Y,'S') use line style 'S' where
%	'S' is any legal linetype as described under the PLOT command.
%
%	See also ROSE, FEATHER, QUIVER.

%	Charles R. Denham, MathWorks 3-20-89
%	Modified, 1-2-92, LS.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

a = ((0:4) + 1./2) ./ 4;
sq = sqrt(2) .* exp(-sqrt(-1) .* 2 .* pi .* a);

xx = [0 1 .8 1 .8].';
yy = [0 0 .08 0 -.08].';
arrow = xx + yy.*sqrt(-1);

if nargin == 2
   if isstr(y)
      s = y;
      y = imag(x); x = real(x);
     else
      s = 'r-';
   end
  elseif nargin == 1
   s = 'r-';
   y = imag(x); x = real(x);
end

x = x(:);
y = y(:);
if length(x) ~= length(y)
   error('X and Y must be same length.');
end

z = (x + y.*sqrt(-1)).';
a = arrow * z;
mx = max(max(abs(a)));
next = lower(get(gca,'NextPlot'));
isholdon = ishold;
b = plot(real(sq), imag(sq), 'w:'); hold on
h = plot(real(a), imag(a), s);
axis('equal')
if ~isholdon
   set(gca,'NextPlot',next);
end
if nargout > 0
   hc = h;
   hb = b;
end
