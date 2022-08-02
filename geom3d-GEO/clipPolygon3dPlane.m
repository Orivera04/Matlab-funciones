function poly2 = clipPolygon3dPlane(poly, plane)
%CLIPPOLYGON3DPLANE clip a 3D polygon with Half-space
%
%   usage :
%   POLY2 = clipPolygon3dPlane(POLY, PLANE)
%   POLY is a [Nx3] array of points, and PLANE is given as :
%   [x0 y0 z0 dx1 dy1 dz1 dx2 dy2 dz2].
%   The result POLY2 is also an array of 3d points, sometimes smaller than
%   poly, and that can be [0x3] (empty polygon).
%
%   POLY2 = clipPolygon3dPlane(POLY, PT0, NORMAL)
%   uses plane with normal NORMAL and containing point PT0.
%
%   TODO: not yet implemented
%
%   There is a problem for non-convex polygons, as they can be clipped in
%   several polygons. Possible solutions:
%   - create another function 'clipConvexPolygon3dPlane' or
%       'clipConvexPolygon3d', using a simplified algorithm
%   - returns a list of polygons instead of a single polygon,
%   - in the case of one polygon as return decide what to return
%   - and rename this function to 'clipPolygon3d'
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 02/08/2005.
%

%   HISTORY
%   04/01/2007: add todo flag

if sum(poly(end, :)==poly(1,:))~=3
    poly = [poly; poly(1,:)];
end

N = size(poly, 1);
edges = [poly([N 1:N-1], :) poly];

b = isLeftOriented(poly, line);

% case of totally clipped polygon
if sum(b)==0
    poly2 = zeros(0, 2);
    return;
end
 

poly2 = zeros(0, 2);

i=1;
while i<=N
    
    if isLeftOriented(poly(i,:), line)
        % keep all points located on the right side of line
        poly2 = [poly2; poly(i,:)];
    else
        % compute of preceeding edge with line
        if i>1
            poly2 = [poly2; intersectLineEdge(line, edges(i, :))];
        end    
        
        % go to the next point on the left side
        i=i+1;
        while i<=N            
            % find the next point on the right side
            if isLeftOriented(poly(i,:), line)
                % add intersection of previous edge
                poly2 = [poly2; intersectLineEdge(line, edges(i, :))];
                
                % add current point
                poly2 = [poly2; poly(i,:)];
                
                % exit the second loop
                break;
            end
            
            i=i+1;
        end
    end
    
    i=i+1;
end

% remove last point if it is the same as the first one
if sum(poly2(end, :)==poly(1,:))==2
    poly2 = poly2(1:end-1, :);
end

