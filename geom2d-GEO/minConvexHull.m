function faces = minConvexHull(nodes, varargin)
%MINCONVEXHULL  return the unique minimal convex hull in 3D
%
%   FACES = minConvexHull(NODES)
%   NODES is a set of 3D points  (as a Nx3 array). The function computes
%   the convex hull, and merge contiguous coplanar faces. The result is a
%   set of polygonal faces, such that there are no coplanar faces.
%   FACES is a cell array, each cell containing the vector of indices of
%   nodes given in NODES for the corresponding face.
%
%   FACES = minConvexHull(NODES, PRECISION)
%   Adjust the threshold for deciding if two faces are coplanar or
%   parallel. Default value is 1e-14.
%
%   Example
%   [n e f] = createCube;
%   f2 = minConvexHull(n);
%   drawPolyhedra(n, f);
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

% 20/07/2006 : add tolerance for coplanarity test
% 21/08/2006 : fix small bug due to difference of methods to test
%   coplanaritity, sometimes resulting in 3 points of a face not coplanar !
%   Also add control on precision


% set up precision
acc = 1e-14;
if length(varargin)>0
    acc = varargin{1};
end

% triangulated convex hull. It is not uniquely defined.
hull = convhulln(nodes);
   
% number of base triangular faces
N = size(hull, 1);

% compute normals of given faces
normals = planeNormal(createPlane(...
    nodes(hull(:,1),:), nodes(hull(:,2),:), nodes(hull(:,3),:)));

% initialize empty faces
faces = {};


% Processing flag for each triangle
% 1 : triangle to process, 0 : already processed
% in the beginning, every triangle face need to be processed
flag = ones(N, 1);

% iterate on each triangle face
for i=1:N
    
    % check if face was already performed
    if ~flag(i)
        continue;
    end

    % indices of faces with same normal
    ind = find(abs(vecnorm(cross(repmat(normals(i, :), [N 1]), normals)))<acc);
    ind = ind(ind~=i);
    
    % keep only coplanar faces (test coplanarity of points in both face)
    ind2 = i;
    for j=1:length(ind)
        if isCoplanar(nodes([hull(i,:) hull(ind(j),:)], :), acc)
            ind2 = [ind2 ind(j)];
        end
    end
    
    
    % compute order of the vertices in current face
    vertices = unique(hull(ind2, :));
    [tmp I]  = angleSort3d(nodes(vertices, :));
    
    % add a new face to the list
    faces = {faces{:}, vertices(I)'};
    
    % mark processed faces
    flag(ind2) = 0;
end

