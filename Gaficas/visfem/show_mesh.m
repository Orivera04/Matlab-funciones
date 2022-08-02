function show_mesh(nodes,coord)
% Call: show_mesh(nodes,coord)
% Input:
%    nodes,coord ... Description of the discretisation
% Graphical output:
%    Mesh

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off; nv= size(coord,1);
trimesh(nodes,coord(:,1),coord(:,2),zeros(nv,1));
view(0,90); axis equal;
title('discretisation');
grid off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%