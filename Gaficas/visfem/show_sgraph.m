function show_sgraph(u,nodes,coord)
% Call: show_sgraph(u,nodes,coord)
% Input:
%    u ... Nx1; Function values in the vertices
%    nodes,coord ... Description of the discretisation
% Graphical output:
%    Coloured and shaded graph according to values of 'u'

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off;
trisurf(nodes,coord(:,1),coord(:,2),u);
shading interp
view(0,90); axis equal;
title('graph')
grid off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%