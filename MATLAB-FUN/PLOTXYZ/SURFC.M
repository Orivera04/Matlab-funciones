function h=surfc(x,y,z,c)
%SURFC	Combination SURF/CONTOUR plot.
%	SURFC(...) is the same as SURF(...) except that a contour plot
%	is drawn beneath the surface.
%
%	Because CONTOUR does not handle irregularly spaced data, this 
%	routine only works for surfaces defined on a rectangular grid.
%	The matrices or vectors X and Y define the axis limits only.
%
%	See also SURF.

%	Clay M. Thompson 4-10-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(1,4,nargin));

if nargin==1,  % Generate x,y matrices for surface z.
  z = x;
  [m,n] = size(z);
  [x,y] = meshgrid(1:n,1:m);

elseif nargin==2,
  z = x; c = y;
  [m,n] = size(z);
  [x,y] = meshgrid(1:n,1:m);

end

if min(size(z))==1,
  error('The surface Z must contain more than one row or column.');
end

% Determine state of system
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% Plot surface
if nargin==2 | nargin==4,
  hs=surf(x,y,z,c);
else
  hs=surf(x,y,z);
end

hold on;

a = get(gca,'zlim');

zpos = a(1); % Always put contour below plot.

% Get D contour data
[cc,hh] = contour3(x,y,z);

%%% size zpos to match the data

for i = 1:length(hh)
        zz = get(hh(i),'Zdata');
        set(hh(i),'Zdata',zpos*ones(size(zz)));
end

if ~hold_state, set(cax,'NextPlot',next); end
if nargout > 0
	h = [hs; hh(:)];
end
