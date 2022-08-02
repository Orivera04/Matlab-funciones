function hout = slice(x,y,z,v,sx,sy,sz,nx)
%SLICE	Volumetric slice plot.
%	SLICE(V,sx,sy,sz,nx) draws slices of volume V at the locations specified
%	in the index vectors sx, sy, and sz.  nx is the number of rows in
%	volume array V.
%
%	SLICE(X,Y,Z,V,sx,sy,sz,nx) draws the slices for the volume locations
%	specified by the triples (X(i),Y(i),Z(i)).
%
%	For example, to evaluate the function  x*exp(-x^2-y^2-z^2) over the 
%	range  -2 < x < 2,  -2 < y < 2,- 2 < z < 2,
%
%	   [x,y,z] = meshgrid(-2:.2:2, -2:.2:2, -2:.2:2);
%	   v = x .* exp(-x.^2 - y.^2 - z.^2);
%	   slice(v,[5 15 21],21,[1 10],21)
%
%	SLICE returns a vector of handles to SURFACE objects.

% 	J.N. Little 1-23-92
%   Revised 4-27-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

if nargin == 5
	nx = sx; sz = v; sy = z; sx = y; v = x;
	[m,nz] = size(v);
	ny = m/nx;
	[x,y,z] = meshgrid(1:nx,1:ny,1:nz);
end
[m,nz] = size(v);
ny = m/nx;

if min(size(x)) == 1
	[x,y,z] = meshgrid(x,y,z);
end

h = [];
for i = 1:length(sx)
	n = sx(i);
	h = [h; surface(x((1:ny)+ny*(n-1),:),y((1:ny)+ny*(n-1),:),z((1:ny)+ny*(n-1),:),v((1:ny)+ny*(n-1),:))];
end

for i = 1:length(sy)
	n = sy(i);
	h = [h; surface(x(n:ny:m,:),y(n:ny:m,:),z(n:ny:m,:),v(n:ny:m,:))];
end

for i = 1:length(sz)
	n = sz(i);
	h = [h; surface(reshape(x(:,n),ny,nx),reshape(y(:,n),ny,nx),...
        reshape(z(:,n),ny,nx),reshape(v(:,n),ny,nx))];
end

if nargout > 0
	hout = h;
end
if ~hold_state
	view(3)
end

% Use FINITE to make sure no NaNs or Infs get passed to CAXIS
u=v(finite(v));
caxis([min(min(u)) max(max(u))])
