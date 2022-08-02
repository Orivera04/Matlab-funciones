function plane = medianPlane(p1, p2)
%MEDIANPLANE create a plane in the middle of 2 points
%
%   plane = medianPlane(P1, P2)
%   plane is perpendicular to line (P1 P2) and contains the midpoint of p1
%   and p2.
%   
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 18/02/2005.
%


p0 = (p1 + p2)/2;
n = p2-p1;

plane = createPlane(p0, n);