function normals = faceNormal(nodes, faces)
%FACENORMAL  compute normal vector of a polyhedron face
%
%   NORMALS = faceNormal(NODES, FACES)
%   NODES is a set of 3D points  (as a Nx3 array), and FACES is either a
%   [Nx3] indices array or a cell array of indices. The function computes
%   the normal of each face.
%   The orientation of t he normal is undefined.
%
%
%   Example
%   [n e f] = createCube;
%   normals1 = faceNormal(n, f);
%
%   pts = rand(50, 3);
%   hull = minConvexHull(pts);
%   normals2 = faceNormal(pts, hull);
%
%   See also
%   drawPolyhedra, convhull, convhulln
%
%
% ------
% Author: David Legland
% e-mail: david.legland@jouy.inra.fr
% Created: 2006-07-05
% Copyright 2006 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).

if isnumeric(faces)
    % compute vector of first edge
	v1 = nodes(faces(:,2),1:3)-nodes(faces(:,1),1:3);
    v2 = nodes(faces(:,3),1:3)-nodes(faces(:,1),1:3);
    
    % normalize vectors
    v1 = v1./repmat(sqrt(sum(v1.*v1, 2)), [1 3]);
    v2 = v2./repmat(sqrt(sum(v2.*v2, 2)), [1 3]);
   
    % compute normals using cross product
	normals = cross(v1, v2, 2);

else
    normals = zeros(length(faces), 3);
    
    for i=1:length(faces)
        pts = nodes(faces{i}, :);
        v1 = normalize3d(pts(2,:)-pts(1,:));
        v2 = normalize3d(pts(3,:)-pts(1,:));
        normals(i, :) = cross(v1, v2, 2);
    end
end

