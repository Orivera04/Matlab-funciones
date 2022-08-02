function plot3in2(x,y,z,width)

% PLOT3IN2 plots 3-dimensional lines as in 2-dimensions,
%      with the thickness of the line proportional to the 3-rd
%      coordinate (z).
%    PLOT3IN2(X) and PLOT3IN2(X,Y) are equivalent to the ordinary
%      routines  PLOT(X) and PLOT(X,Y).
%    PLOT3IN2(X,Y,Z) is equivalent to PLOT(X,Y) but with line
%      thickness proportional to Z.
%      All three variavles X, Y, Z must have the same size
%      (vectors or matrices). Usual MATLAB columnwise
%      vectorization is applied.
%    PLOT3IN2(X,Y,Z,WIDTH) also specifies maximum line width
%      relative to the figure size.
%      Works with 4.1 or later version.

%  Kirill Pankratov,  kirill@plume.mit.edu
%  April 27, 1994

widthdflt = .01;   % Default for maximum width of the line relative
                    % to the figure size

 % Handle input .....................................................
if nargin==0
  disp([10 '  Error: not enough input arguments' 10])
  return
end
if nargin==1, plot(x),   return, end
if nargin==2, plot(x,y), return, end
if nargin==3, width = widthdflt; end

% Now if truly 3 dimensions (input arguments) .......................
fig = gcf;
%    fig = get(0,'currentfigure');
if strcmp(get(fig,'NextPlot'),'new')  % J.M. Shramm suggestion
  fig = figure;
end
oldunits = get(fig,'units');
set(fig,'units','pixels')
szf = get(fig,'pos');
szf = max(szf(3:4));     %  Size of the figure
lw = ceil(szf*width);    % Number of thickenings for each line

holdst = ishold;         % Hold state
sz = size(x);

 % Determine limits and scales ............
C = zeros(size(x));
C = C+isnan(x)+isnan(y)+isnan(z);
fnd = find(C==0);
xlim = [min(x(fnd)) max(x(fnd))];
ylim = [min(y(fnd)) max(y(fnd))];
zlim = [min(z(fnd)) max(z(fnd))];
scx = (xlim(2)-xlim(1))*width/2;
scy = (ylim(2)-ylim(1))*width/2;

 % Calculate differentials ................
dx = zeros(size(x)); dy = dx;
dx(2:sz(1)-1,:) = (x(3:sz(1),:)-x(1:sz(1)-2,:))/2;
dy(2:sz(1)-1,:) = (y(3:sz(1),:)-y(1:sz(1)-2,:))/2;
C = sqrt(dx.^2+dy.^2+eps);  % Length of the line element dl
dx = dx./C;  % dx-elements of the line
dy = dy./C;  % dy-elements of the line
z = (z-zlim(1))/(zlim(2)-zlim(1));  % Normalized z

 % Plot bounding lines ....................
h = plot(x+scx*z.*dy,y-scy*z.*dx);
set(h,'clipping','off')
hold on
h = plot(x-scx*z.*dy,y+scy*z.*dx);
set(h,'clipping','off')

 % Fill inside ............................
for jw = 1:lw
  fnd = find(z<jw/lw);
  length(fnd);
  x(fnd) = nan*ones(size(fnd));
  y(fnd) = nan*ones(size(fnd));
  h = plot(x,y,'linewidth',.5*(jw+1));
  set(h,'clipping','off')
end

 % Set units and hold to initial state .....
set(fig,'units',oldunits)
if ~holdst, hold off, end
