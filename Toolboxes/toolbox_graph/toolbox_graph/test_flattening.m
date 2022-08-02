% test for triangulation plotting
% (i.e. flattening of an disk-shaped 3D model)
%
%   Copyright (c) 2005 Gabriel Peyré

function test_flattening(filename)

if nargin<1
    filename = 'nefertiti.off';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file loading
[vertex,face] = read_off(filename);
if size(vertex,1)<size(vertex,2)
    vertex = vertex';
end
if size(face,1)<size(face,2)
    face = face';
end
A = triangulation2adjacency(face);
xy = vertex(:,1:2);

n = length(A);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original model
clf;
subplot(2,2,1);
plot_mesh(vertex,face);
title('Original model');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orthogonal projection
if 0
subplot(2,2,1);
gplot(A,xy,'k.-');
axis tight;
axis square;
axis off;
title('Orthogonal projection');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spectral graph drawing : use the eigenvectors of the laplacian
lap = compute_laplacian(A);

disp('Performing SVD.');
tic;
[U,S,V] = svd(lap);
disp( sprintf('CPU time : %.2f.', toc) );
xy_spec = U(:,(n-2):(n-1));
xy_spec = rectify_embedding(xy,xy_spec);
plot_cur_graph(A,xy_spec,2, 'Combinatorial laplacian');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% same but use conformal laplacian
lap = compute_geometric_laplacian(vertex,face,'conformal');

disp('Performing SVD.');
tic;
[U,S,V] = svd(lap);
disp( sprintf('CPU time : %.2f.', toc) );
xy_spec = U(:,(n-2):(n-1));
xy_spec = rectify_embedding(xy,xy_spec);
plot_cur_graph(A,xy_spec,3, 'Conformal laplacian');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use IsoMap
% build distance graph

D = build_euclidean_weight_matrix(A,vertex,Inf);
xy_spec = isomap(D); 
xy_spec = rectify_embedding(xy,xy_spec);
plot_cur_graph(A,xy_spec,4, 'Isomap');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_cur_graph(A,xy_spec,k, thetitle)

subplot(2,2,k);
gplot(A,xy_spec,'k.-');
axis tight;
axis square;
axis off;
title(thetitle);