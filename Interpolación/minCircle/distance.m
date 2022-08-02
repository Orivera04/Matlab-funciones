function distance = dist(x,y)

% DISTANCE   find the distance between two points in the Cartesian space
%
% Usage:
%   distance = dist(x,y), where x and y are a 1x2 (2D) or 1x3 (3D) vectors.
%

distance = sqrt(sum((x - y).^2));