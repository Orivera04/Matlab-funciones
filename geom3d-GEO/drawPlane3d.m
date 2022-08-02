function varargout = drawPlane3d(plane, varargin)
%DRAWPLANE3D draw a plane clipped in the current window
%
%   drawPlane3d(plane)
%   plane = [x0 y0 z0  dx1 dy1 dz1  dx2 dy2 dz2];
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/02/2005.
%

%   HISTORY

param = 'm';
if length(varargin)>0
    param = varargin{:};
end

lim = get(gca, 'xlim');
xmin = lim(1);
xmax = lim(2);
lim = get(gca, 'ylim');
ymin = lim(1);
ymax = lim(2);
lim = get(gca, 'zlim');
zmin = lim(1);
zmax = lim(2);


% line corresponding to cube edges
lineX00 = [xmin ymin zmin 1 0 0];
lineX01 = [xmin ymin zmax 1 0 0];
lineX10 = [xmin ymax zmin 1 0 0];
lineX11 = [xmin ymax zmax 1 0 0];

lineY00 = [xmin ymin zmin 0 1 0];
lineY01 = [xmin ymin zmax 0 1 0];
lineY10 = [xmax ymin zmin 0 1 0];
lineY11 = [xmax ymin zmax 0 1 0];

lineZ00 = [xmin ymin zmin 0 0 1];
lineZ01 = [xmin ymax zmin 0 0 1];
lineZ10 = [xmax ymin zmin 0 0 1];
lineZ11 = [xmax ymax zmin 0 0 1];


% compute itnersection point with each plane
piX00 = intersectPlaneLine(plane, lineX00);
piX01 = intersectPlaneLine(plane, lineX01);
piX10 = intersectPlaneLine(plane, lineX10);
piX11 = intersectPlaneLine(plane, lineX11);
piY00 = intersectPlaneLine(plane, lineY00);
piY01 = intersectPlaneLine(plane, lineY01);
piY10 = intersectPlaneLine(plane, lineY10);
piY11 = intersectPlaneLine(plane, lineY11);
piZ00 = intersectPlaneLine(plane, lineZ00);
piZ01 = intersectPlaneLine(plane, lineZ01);
piZ10 = intersectPlaneLine(plane, lineZ10);
piZ11 = intersectPlaneLine(plane, lineZ11);

points = [...
    piX00;piX01;piX10;piX11; ...
    piY00;piY01;piY10;piY11; ...
    piZ00;piZ01;piZ10;piZ11;];

% check validity : keep only points inside window
ac = 1e-15;
vx = points(:,1)>=xmin-ac & points(:,1)<=xmax+ac;
vy = points(:,2)>=ymin-ac & points(:,2)<=ymax+ac;
vz = points(:,3)>=zmin-ac & points(:,3)<=zmax+ac;
valid = vx & vy & vz;
pts = points(valid, :);

% the two spanning lines of the plane
d1 = plane(:, [1:3 4:6]);
d2 = plane(:, [1:3 7:9]);
u1 = linePosition3d(pts, d1);
u2 = linePosition3d(pts, d2);

% reorder vertices in the correct order
ind = convhull(u1, u2);
ind = ind(1:end-1);

% draw the patch
h = patch(pts(ind, 1), pts(ind, 2), pts(ind, 3), param);

if nargout>0
    varargout{1}=h;
end