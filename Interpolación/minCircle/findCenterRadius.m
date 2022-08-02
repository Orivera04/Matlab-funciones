function [C,Raduis] = findCenterRadius(p1,p2,p3)

% FINDCENTERRADIUS      finds the center and radius of a circle defined by three points.
%
% Usage:
%   [C,Raduis] = findCenterRadius(p1,p2,p3), where:
%       C: the circle's centre
%       Raduis: the circle's radius
%       p1, p2, p3: a two element vectors with the points (x,y) coordinates

Xc = (p3(1)*p3(1) * (p1(2) - p2(2)) + (p1(1)*p1(1) + (p1(2) - p2(2))*(p1(2) - p3(2))) * (p2(2) - p3(2)) + p2(1)*p2(1) * (-p1(2) + p3(2))) / (2 * (p3(1) * (p1(2) - p2(2)) + p1(1) * (p2(2) - p3(2)) + p2(1) * (-p1(2) + p3(2))));

Yc = (p2(2) + p3(2))/2 - (p3(1) - p2(1))/(p3(2) - p2(2)) * (Xc - (p2(1) + p3(1))/2);

C = [Xc Yc];

Raduis = distance(C,p1);