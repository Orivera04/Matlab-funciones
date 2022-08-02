function circle = intersectPlaneSphere(plane, sphere)
%INTERSECTPLANESPHERE return intersection between a plane and a sphere
%
%   GC = intersectPlaneSphere(PLANE, SPHERE) returns the grreat circle
%   which is the intersection of the given plane and sphere.
%   PLANE  : [x0 y0 z0  dx1 dy1 dz1  dx2 dy2 dz2]
%   SPHERE : [xc yc zc  R]
%   GC     : [PHI THETA PSI]
%   
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 18/02/2005.
%

%   HISTORY

% origin of the spheres
sphere0 = sphere(:,1:3);

% radius of spheres
Rs = sphere(:,4);

% projection of sphere center on plane -> gives circle center
circle0 = projPointOnPlane(sphere0, plane);

% radius of circles
d = distancePoints3d(sphere0, circle0);
Rc = sqrt(Rs.*Rs - d.*d);

% normal of planes = normal of circles
nor = planeNormal(plane);

% convert to angles
[t p r] = cart2sph(nor(:,1), nor(:,2), nor(:,3));
phi = t;
theta = pi/2-p;
psi = zeros(size(plane, 1), 1);

% create structure for circle
circle = [circle0 Rc phi theta psi];
