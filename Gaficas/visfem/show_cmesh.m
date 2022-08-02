function show_cmesh(u,nodes,coord)
% Call: show_cmesh(u,nodes,coord)
% Input:
%    u ... Nx1; Function values in the vertices
%    nodes,coord ... Description of the discretisation
% Graphical output:
%    Coloured mesh according to values of 'u'

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off;
trimesh(nodes,coord(:,1),coord(:,2),u);
view(0,90); axis equal;
title('coloured discretisation');
grid off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%