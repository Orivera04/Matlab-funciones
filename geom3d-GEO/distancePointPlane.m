function d = distancePointPlane(point, plane)
%DISTANCEPOINTPLANE compute euclidean distance betwen 3D point and plane
%
%   D = distancePointPlane(POINT, PLANE) return the distance between point
%   POINT and the plane PLANE, given as :
%   POINT : [x0 y0 z0]
%   PLANE : [x0 y0 z0 dx1 dy1 dz1 dx2 dy2 dz2]
%   D     : scalar  
%   
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 18/02/2005.
%

%   HISTORY


% normalized plane normal
n = normalize3d(cross(plane(:,4:6), plane(:, 7:9), 2));


% Uses hessian form, ie : N.p = d
% I this case, d can be found as : -N.p0, when N is normalized
d = -dot(n, plane(:,1:3)-point(:,1:3), 2);

