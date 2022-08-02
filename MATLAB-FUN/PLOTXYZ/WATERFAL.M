function h = waterfall(x,y,z,c)
%WATERFALL Waterfall plot.
%	WATERFALL(...) is the same as MESH(...) except that the column lines of
%	the mesh are not drawn - thus producing a "waterfall" plot.  For
%	column-oriented data analysis, use WATERFALL(Z') or 
%	WATERFALL(X',Y',Z').
%
%	See also MESH.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

a = newplot;
if nargin == 1
	z = x;
	c = z;
	x = 1:size(z,2);
	y = 1:size(z,1);
elseif nargin == 2
	z = x;
	c = y;
	x = 1:size(z,2);
	y = 1:size(z,1);
elseif nargin == 3
	c = z;
end
if min(size(x)) == 1 | min(size(y)) == 1
	[x,y]=meshgrid(x,y);
end

% Add 2 data points to the beginning and three data points at the end
% of each row for a patch.  Two of the points on each side are used
% to make sure the curtain is a constant color under 'interp' or
% 'flat' edge color.  The final point on the right is used to
% make bottom edge invisible.
x = [x(:,[1 1]) x x(:,size(x,2)*[1 1 1])];
y = [y(:,[1 1]) y y(:,size(y,2)*[1 1 1])];
c0 = (max(max(c))+min(min(c)))/2;
z0 = min(min(z));
if z0==max(max(z)), % Special case for a constant surface
  if z0==0, z0 = -1; else, z0 = z0 - abs(z0)/2; end
end

z = [z0*ones(size(x,1),1) z(:,1) z z(:,size(z,2)) z0*ones(size(x,1),2) ];
c = [c0*ones(size(c,1),2)  c c0*ones(size(c,1),2) nan*ones(size(x,1),1)];
fc = get(gca,'color');
if strcmp(fc,'none'), fc = get(gcf,'color'); end
hp = patch(x',y',z',c','facecolor',fc,'edgecolor','flat');
view(3)

% return handles, if requested
if nargout > 0
	h = hp;
end

