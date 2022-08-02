function [area]=areaintersection(set1, set2, resolution)

% Function gives the approximate area of intersection of two polygons
%     whose vertices are given by set1 and set2. 
% 
% Note that implementation of this function requires the standard Matlab
%     function "inpolygon"
% 
% STANDARD CALL
% 
% area = areaintersection(set1, set2, resolution)
%     
%     
% INPUTS
% 
% set1 : an N x 2 matrix of the form (x1, y1; x1, y2; ...) giving the
%     vertices of a polygon
% set2 : an M x 2 matrix of the form (x1, y1; x1, y2; ...) giving the
%     vertices of a second polygon
% resolution : a positive scalar that determines the accuracy of the
%     approximation. The larger the value the greater the accuracy and the 
%     longer the evaluation time. The matlab function "inpolygon" is the
%     real limiting factor in terms of execution time
%     
% OUTPUT
% 
% area : a scalar value that represents the area of intersection of the two
%     polynomials in standard units squared
% 
% 
% 
%   Paul Koprowski 2007
%   paulkoprowski@hotmail.com
%   
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Checks the input arguments
if nargin~=3
    error('wrong number of inputs');
end
sset1=size(set1);
sset2=size(set2);
if sset1(1,1)<2
    error('set1 has too few rows');
end
if sset2(1,1)<2
    error('set2 has too few rows');
end
if sset1(1,2)<2
    error('set1 has too few columns');
end
if sset2(1,2)<2
    error('set2 has too few columns');
end
s=size(resolution);
if s(1,1)~=1
    error('resolution must be a scalar');
end
if s(1,2)~=1
    error('resolution must be a scalar');
end
% creates a hull of all point in both polygons
hset = [set1;set2];
    % Extreme boundaries of hull
maxx=max(hset(:,1));
minx=min(hset(:,1));
maxy=max(hset(:,2));
miny=min(hset(:,2));

% Generates matrix containing all points of both polygons and then some

stepwidthx = (maxx-minx)/resolution;
stepwidthy = (maxy-miny)/resolution;
hullx = ones(resolution+1,1)*[minx:stepwidthx:maxx];
hully = ([miny:stepwidthy:maxy]')*ones(1,resolution+1);

% Uses "inpolygon" function to determine points inside each polygon

[poly1] = inpolygon(hullx,hully,set1(:,1),set1(:,2));
[poly2] = inpolygon(hullx,hully,set2(:,1),set2(:,2));

% Finds the intersection points of the two polygons

int = and(poly1,poly2);

% Multiplies the area of each box in the hull by the number of boxes
% contained in each polygon to approximate the total area of intersection

area = (stepwidthx*stepwidthy*sum(sum(int)));


