function xpezplt(f)
%XPEZPLT Expo version of EZPLOT for use with XPCALC.

% 	Restricted EZPLOT: 
%		f must have exactly one symbolic variable,
%		and it must be x.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

xrange = [-2*pi 2*pi];
v = 'x';

% this is the VECTORIZE function in the Symbolic Math Toolbox
F = f;
l = length(F);
for k = fliplr(find((F=='^') | (F=='*') | (F=='/')))
   F = [F(1:k-1) '.' F(k:l)];
   l = l+1;
end

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

if (npts > 1) 
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
   y = real(y);
end

% Determine y scale so that "most" of the y values
% are in range, but singularities are off scale.

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

plot(x,y)
axis([xmin xmax ymin ymax])
grid on
if nargin < 3
   if length(f) <= 50
      title(f)
   else
      k = length(f);
      title([f(1:25) ' ~~~ ' f(k-24:k)])
   end
   if ~isnan(v), xlabel(v), end
end
