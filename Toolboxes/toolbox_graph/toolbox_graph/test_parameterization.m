% test for triangulation parameterization
% (i.e. parameterization of an disk-shaped 3D model)
%
%   Copyright (c) 2005 Gabriel Peyré


% test of mesh parameterization.
%
%   Copyright (c) 2004 Gabriel Peyré

global lang;
if ~strcmp(lang,'eng') % default is french
    lang = 'fr';
end

filename = 'mannequin.off';
filename = 'nefertiti.off';
[vertex,face] = read_off(filename);
A = triangulation2adjacency(face);
xy = vertex(:,1:2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute 1-ring
ring = compute_1_ring(face);


boundary_types = {'circle','square','triangle'};
nbound = length(boundary_types);
lap_types = {'combinatorial','conformal'};
nlap = length(lap_types);
    

kk = 0;
for l = lap_types
k = 0;
for b = boundary_types
    kk = kk+1;
    k = k+1;
    
    boundary_type = cell2mat(b);
    lap_type = cell2mat(l);
    
    k = k+1;
    str = sprintf('%s laplacian, %s boundary', lap_type, boundary_type);
    disp(['Computing parameterization : ', str, '.']);
    xy_spec = compute_parametrization(vertex,face,lap_type,boundary_type,ring);
    % essaie de redresse le graphe
    xy_spec = rectify_embedding(xy,xy_spec);

    subplot(nlap,nbound,kk);
    gplot(A,xy_spec,'k.-');
    axis tight;
    axis square;
    axis off;
    
    str = sprintf('%s boundary, %s laplacian', boundary_type, lap_type);
    
    title(str);
end

end
