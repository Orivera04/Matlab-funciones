function varargout = drawPolyhedra(varargin)
%DRAWPOLYHEDRA draw polyhedra defined by vertices and faces
%
%   drawPolyhedra(NODES, FACES)
%   Draw the polyhedra defined by vertices NODES and the faces FACES. 
%   NODES is a [NNx3] array containing coordinates of vertices, and FACES
%   is either a [NFx3] or [NFx4] array containing indices of vertices of
%   the tria,gular or rectangular faces.
%   FACES can also be a cell array, in the content of each cell is an array
%   of indices to the nodes of the current face. Faces can have different
%   number of vertices.
%   
%   H = drawPolyhedra(...) also return handles to the created patches.
%
%   Example:
%   [n f] = createSoccerBall;
%   drawPolyhedra(n, f);
%
%   See also : drawPolygon
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 10/02/2005.
%

%   HISTORY
%   07/11/2005 update doc.
%   04/01/2007 typo
%   18/01/2007 add support for 2D polyhedra ("nodes" is N-by-2 array), and
%       make 'cnodes' a list of points instead of a list of indices


% process input parameters
if length(varargin)<=2
    nodes = varargin{1};
    faces = varargin{2};
else
    error ('wrong number of arguments in "drawPolyhedra"');
end

color = [1 0 0];

% --------------------
% main loop : for each face

hold on;
if iscell(faces)
    % array CELLS is a cell array
    h = zeros(length(faces(:)), 1);
    if size(nodes, 2)==3
        for i=1:length(faces(:))
            % get nodes of the cell
            cnodes = nodes(faces{i}', :);
            h(i) = patch(cnodes(:, 1), cnodes(:, 2), cnodes(:, 3), color);
        end
    elseif size(nodes, 2)==2
        for i=1:length(faces(:))
            % get nodes of the cell
            cnodes = nodes(faces{i}', :);
            h(i) = patch(cnodes(:, 1), cnodes(:, 2), color);
        end
    end
else
    % array FACES is a NC*NV indices array, with NV : number of vertices of
    % each face, and NC number of faces
    h = zeros(size(faces, 1), 1);
    if size(nodes, 2)==3
        for i=1:size(faces, 1)
            % get nodes of the cell
            cnodes = nodes(faces(i,:)', :);
            h(i) = patch(cnodes(:, 1), cnodes(:, 2), cnodes(:, 3), color);
        end
    elseif size(nodes, 2)==2
        for i=1:size(faces, 1)
            % get nodes of the cell
            cnodes = nodes(faces(i,:)', :);
            h(i) = patch(cnodes(:, 1), cnodes(:, 2), color);
        end
    end
end

% format output parameters
if nargout>0
    varargout{1}=h;
end