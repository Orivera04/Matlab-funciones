function [elon,nlat] = intreg(elon1,nlat1,elon2,nlat2)

% INTREG - Intersection of two geographic regions.
% [elon,nlat] = intreg(elon1,nlat1,elon2,nlat2)
%
% Given two geographic regions bordered by the closed sequences 
% (elon1,nlat1) and (elon2,nlat2) where 'elon1' and 'elon2' are 
% vectors of east longitude degrees, and 'nlat1' and 'nlat2' are 
% vectors of north latitude degrees, calculate the region defined 
% by the intersection.  Assumes close sampling of the border contours, 
% and that both the input regions and the intersection region have 
% the property that great circle arcs directed outward from their 
% geographic centers intersect their boundaries only once. 
%
% P.G. Bonanni (adapted from code by Irfan Ali)
% 7/10/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Normalize regions to prevent phase-wrap problems
elon1 = unwrap(elon1*deg2rad)*rad2deg;  elon1o=mean(elon1);
elon2 = unwrap(elon2*deg2rad)*rad2deg;  elon2o=mean(elon2);
elon1 = elon1 + (pvdegs(elon1o)-elon1o);
elon2 = elon2 + (pvdegs(elon2o)-elon2o);

% Geographic "center" points
elon1o = mean(elon1);
nlat1o = mean(nlat1);
elon2o = mean(elon2);
nlat2o = mean(nlat2);

% Express region boundaries in Cartesian ECF coordinates
X1 = posllr(elon1,nlat1);
X2 = posllr(elon2,nlat2);

% Express center points similarly
X1o = posllr(elon1o,nlat1o);
X2o = posllr(elon2o,nlat2o);


% DETERMINE WHICH POINTS ON REGION 1 BOUNDARY LIE INSIDE REGION 2.

% Project all points onto tangent plan defined at geographic center of Region 2
[east,north,zenith] = ucompass(elon2o,nlat2o);  Q = [east,north,zenith];
X12 = [X1(:,1)-X2o(1), X1(:,2)-X2o(2), X1(:,3)-X2o(3)] * Q;
X22 = [X2(:,1)-X2o(1), X2(:,2)-X2o(2), X2(:,3)-X2o(3)] * Q;
x12 = X12(:,1) + j*X12(:,2);  % complex polygon
x22 = X22(:,1) + j*X22(:,2);  % complex polygon

% Find indices of enclosed points
k12 = inside(x12,x22);


% DETERMINE WHICH POINTS ON REGION 2 BOUNDARY LIE INSIDE REGION 1.

% Project all points onto tangent plan defined at geographic center of Region 1
[east,north,zenith] = ucompass(elon1o,nlat1o);  Q = [east,north,zenith];
X21 = [X2(:,1)-X1o(1), X2(:,2)-X1o(2), X2(:,3)-X1o(3)] * Q;
X11 = [X1(:,1)-X1o(1), X1(:,2)-X1o(2), X1(:,3)-X1o(3)] * Q;
x21 = X21(:,1) + j*X21(:,2);  % complex polygon
x11 = X11(:,1) + j*X11(:,2);  % complex polygon

% Find indices of enclosed points
k21 = inside(x21,x11);


% DEFINE INTERSECTION REGION AND RE-ORDER POINTS BY DIRECTION FROM GEOGRAPHIC CENTER

% Assemble points on region boundary
elon = [elon1(k12); elon2(k21)];
nlat = [nlat1(k12); nlat2(k21)];

% Geographic "center" point
elon0 = mean(elon);
nlat0 = mean(nlat);

% Express region boundary and center point ...
% in Cartesian ECF coordinates
X  = posllr(elon,nlat);
Xo = posllr(elon0,nlat0);

% Project points onto tangent plan defined at geographic center
[east,north,zenith] = ucompass(elon0,nlat0);  Q = [east,north,zenith];
X = [X(:,1)-Xo(1), X(:,2)-Xo(2), X(:,3)-Xo(3)] * Q;
x = X(:,1) + j*X(:,2);  % complex polygon

% Establish order of points based on phase at polygon vertices
[dummy,i] = sort(angle(x));

% Re-order boundary points
elon = elon(i);
nlat = nlat(i);
