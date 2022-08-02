function theta = dihedralAngle(plane1, plane2)
%DIHEDRALANGLE compute dihedral angle between 2 planes
%
%   THETA = DIHEDRALANGLE(PLANE1, PLANE2)
%   
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/02/2005.
%

%   HISTORY

n1 = normalize3d(planeNormal(plane1));
n2 = normalize3d(planeNormal(plane2));
theta = pi-acos(dot(n1, n2, 2));