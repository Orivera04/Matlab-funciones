function [A,vertex1] = compute_dual_graph(face,vertex)

% compute_dual_graph - compute the dual graph of a given triangulation
%
%   [A,vertex1] = compute_dual_graph(face,vertex);
%
%   'A' is the adjacency matrix of the abstract dual graph
%   (recall that this graph link togeter adjacent faces
%   in the triangulation).
%
%   'vertex' is optional, and if given, the position of the vertex
%   of the dual graph (contained in 'vertex1') will 
%   the centroids of the face's vertex positions.
%   
%   Copyright (c) 2004 Gabriel Peyré

nface = size(face,1);
nvert = max(max(face));

fring = compute_face_ring(face);


if nargin==2
    d = size(vertex,2); % output dimension  
    vertex1 = zeros(nface, d);    
end

A = zeros(nface,nface);
for i=1:nface
    ring = fring{i};
    if nargin==2
        pos = zeros(1,d);
        for j=1:3
            pos = pos + vertex(face(i,j),:);    
        end
        pos = pos/3;
        vertex1(i,:) = pos;
    end
    for j=1:length(ring)
        A(i,ring(j)) = 1;
        A(ring(j),i) = 1;
    end
end