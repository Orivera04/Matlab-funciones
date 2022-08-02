function aspectRatio = aspect45(x,y)
%  determine aspect ratio to bank data to 45 degrees
%  aspectRatio = aspect45(x,y)
%  x,y  data points

% Copyright (c) 1998-2001 by Datatool
% $Revision: 1.10 $

%  sort points in order of x
xy = [x(:) y(:)];
xy = sortrows(xy);
x = xy(:,1);
y = xy(:,2);

%  computes deltas
h = diff(x);
v = diff(y);

%  define min and max acceptable aspect ratios
amin = 0.2;
amax = 1/amin;

%  find acceptable aspect ratio for banking closest to 45 degrees
%  Details depend on matlab version.
thisVersion = version;
if thisVersion(1)>5
	options = optimset('fminbnd');
	options = optimset(options,'Display','off');
	aspectRatio = fminbnd('banker',amin,amax,options,h,v);
else
	aspectRatio = fmin('banker',amin,amax,[],h,v);
end
