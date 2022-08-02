function ezplot(f,xrange,fig)
%EZPLOT	Easy to use function plotter.
%	EZPLOT(f) plots a graph of f(x) where f is a symbolic 
%	expression representing a mathematical expression that 
%	involves a single symbolic variable, say 'x'.  
%	The range of the x-axis is roughly between -2*pi and 2*pi.
%
%	EZPLOT(f,[xmin xmax]) uses the specified x-range instead of 
%	the default [-2*pi, 2*pi].
%
%	EZPLOT(f,[xmin xmax],fig) uses the specified figure number 
%	instead of the current figure.
%
%	Examples:
%	    ezplot('erf(x)')
%	    ezplot erf(x)
%	    ezplot('tan(sin(x))-sin(tan(x))')
%	    ezplot tan(sin(x))-sin(tan(x))
%
%	See also SYMVAR.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.11 $  $Date: 1994/01/24 22:36:54 $

% Set defaults

if ~isstr(f), f = sym(f); end
if nargin < 2, xrange = [-2*pi 2*pi]; end
if isstr(xrange), xrange = eval(xrange); end
if nargin < 3, fig = gcf; end
if (nargin == 3) & isstr(fig)
   xrange = [xrange eval(fig)]; fig = gcf;
end

% Make the symbolic variable 'x' and vectorize the expression.

v = symvar(f,0:1);
if isnan(v)
   error('Symbolic variable not uniquely determined.')
elseif isempty(v) 
   ispi = any(findstr(f,'pi'));
   if exist(f) > 1 & ~ispi
      F = [f '(x)'];
   elseif ~any(isletter(f)) | ispi
      F = [f '*ones(size(x))'];
   else
      error('Symbolic variable not uniquely determined.')
   end
elseif v ~= 'x'
   F = symvars(f,'x',v);
else
   F = f;
end
F = vectorize(F);

% Sample on initial interval.

npts = 385;
t = (0:npts-1)/(npts-1);
xmin = min(xrange);
xmax = max(xrange);
x = xmin + t*(xmax-xmin);
y = eval(F);
k = find(abs(imag(y)) > 1.e-6*abs(real(y)));
if any(k), x(k) = []; y(k) = []; npts = length(y); end

% Reduce to an "interesting" x interval.

if (npts > 1) & (nargin < 2)
   dx = x(2)-x(1);
   dy = diff(y)/dx;
   dy(npts) = dy(npts-1);
   k = find(abs(dy) > .01);
   if isempty(k), k = 1:npts; end
   xmin = x(min(k));
   xmax = x(max(k));
   if xmin < floor(4*xmin)/4 + dx, xmin = floor(4*xmin)/4; end
   if xmax > ceil(4*xmax)/4 - dx, xmax = ceil(4*xmax)/4; end
   x = xmin + t*(xmax-xmin);
   y = eval(F);
   k = find(abs(imag(y)) > 1.e-6*abs(real(y)));
   if any(k), y(k) = NaN*ones(size(k)); end
end

% Determine y scale so that "most" of the y values
% are in range, but singularities are off scale.

y = real(y);
u = sort(y(finite(y)));
npts = length(u);
if npts > 4
   del = u(7*npts/8) - u(npts/8);
   ymin = max(u(1)-del/8,u(npts/8)-del);
   ymax = min(u(npts)+del/8,u(7*npts/8)+del);
elseif npts > 0
   ymin = u(1);
   ymax = u(npts);
else
   ymin = 0;
   ymax = 0;
end
if ymin == ymax, ymin = ymin-1; ymax = ymax+1; end
 
% Eliminate vertical lines at discontinuities.
 
k = 2:length(y);
k = find( ((y(k) > ymax/2) & (y(k-1) < ymin/2)) | ...
          ((y(k) < ymin/2) & (y(k-1) > ymax/2)) );
if any(k), y(k) = NaN*ones(size(k)); end

% Plot the function

figure(fig);
plot(x,y)
axis([xmin xmax ymin ymax])
grid
if ~isnan(v), xlabel(v), end

% If necessary, shorten string to fit in title space.

ylim = abs(get(gca,'ylim'));
if min(ylim) <= 1.e-2 | max(ylim) >= 1.e4
   tlen = 49;
else
   tlen = 71;
end
if length(f) > tlen
   k = length(f);
   l = (tlen-5)/2;
   f = [f(1:l) ' ~~~ ' f(k-l+1:k)];
end
title(f)
