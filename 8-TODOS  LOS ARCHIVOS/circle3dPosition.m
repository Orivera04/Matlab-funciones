function theta = circle3dPosition(point, circle)
%CIRCLE3DPOSITION return the angular position of a point on a 3D circle
%
%   CIRCLE3DPOSITION(POINT, CIRCLE)
%   with POINT : [xp yp zp]
%   and CIRCLE : [X0 Y0 Z0 R PHI THETA] or [X0 Y0 Z0 R PHI THETA PSI]
%
%   return angular position of point on the circle.
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/02/2005
%

%   HISTORY

% get center and radius
xc = circle(:,1);
yc = circle(:,2);
zc = circle(:,3);
%r  = circle(:,4);

% get angle of normal
phi     = circle(:,5);
theta   = circle(:,6);

% get roll
% if size(circle, 2)==7
%     psi = circle(:,7);
% else
%     psi = zeros(size(circle, 1), 1);
% end


% find origin of the circle
ori = circle3dOrigin(circle);

% create plane containing the circle
plane = createPlane([xc yc zc], [phi theta]);

% find position of point on the circle plane
pp0 = planePosition(ori,    plane);
pp  = planePosition(point,  plane);

% compute angles in the planes
theta0 = mod(atan2(pp0(:,2), pp0(:,1)) + 2*pi, 2*pi);
theta  = mod(atan2(pp(:,2), pp(:,1)) + 2*pi - theta0, 2*pi);

