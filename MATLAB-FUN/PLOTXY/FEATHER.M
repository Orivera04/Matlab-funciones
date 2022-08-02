function feather(x,y,s)
%FEATHER Feather plot.
%	FEATHER(Z) draws a graph that displays the angle and magnitude
%	of the complex elements of Z as arrows emanating from equally
%	spaced points along a horizontal axis.
%
%	FEATHER(X,Y) is equivalent to FEATHER(X+i*Y).  It displays the
%	feather plot for the angles and magnitudes of the elements of
%	matrices X and Y.
%
%	FEATHER(Z,'S') and FEATHER(X,Y,'S') use line style 'S' where
%	'S' is any legal linetype as described under the PLOT command.
%
%	See also COMPASS, ROSE, QUIVER.

%	Charles R. Denham, MathWorks 3-20-89
%	Modified 1-2-92, ls.
%	Modified 12-7-93 Mark W. Reichelt
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if isstr(x)
	error('First argument must be numeric.');
end
xx = [0 1 .8 1 .8]';
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
if isstr(x) | isstr(y)
	error('First 1 or 2 numeric arguments must be numeric.')
end
[st,co] = colstyle(s);

x = x(:);
y = y(:);
if length(x) ~= length(y)
   error('X and Y must be the same length.');
end
[m,n] = size(x);

z = (x + y.*sqrt(-1)).';
a = arrow * z + ones(5,1)*(1:m);
mx = max(a(find(~isnan(a))));

% Plot the feather
plot(real(a), imag(a), s, [1 m], [0 0], s);
if strcmp('auto',axis('state'))
	axis([0 mx [-mx mx]*.3]);
end

