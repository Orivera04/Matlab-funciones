function show_macro(nodes,coord)
% Call: show_macro(nodes,coord)
% Globals:
%    coord nodes ... Discretisation
% Graphical output:
%    Macro-mesh with numbering

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002 (W. Doerfler). Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute barycenters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = coord(:,1)'; y = coord(:,2)';% Better to work with these ...
co= size(nodes,2);% No of corners
xs= [sum(x(nodes'))/co;sum(y(nodes'))/co]';% Barycenters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); hold off;
nt= size(nodes,1); nv= max(max(nodes));% No of triangeles, vertices
trimesh(nodes,x,y,zeros(nv,1)); axis equal; hold on;
for t=1:nt text(xs(t,1),xs(t,2),num2str(t),'Color','r'); end;% t-numbers
for i=1:nv text(x(i)*1.1,y(i),num2str(i)); end;% v-numbers
title('macro discretisation with triangle and node numbers');
view(0,90); grid off; hold off;
fprintf('Press <return> to continue\n'); pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
