function show_grad(u,nodes,coord,scale)
% Call: show_grad(u,nodes,coord)
% Input:
%    u ... Nx1; Function values in the vertices
%    nodes,coord ... Description of the discretisation
%    scale ... A relative scaling factor for the arrows
% Graphical output:
%    Vector field 'gradient of u'

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Local definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc= zeros(3,1); xloc= zeros(3,2); xmid= zeros(2,1);
uloc2= zeros(3,1); xloc2= zeros(3,2);
zykle= [1 2 3 4 1 2 3 4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prepare graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
hold on
view(0,90);
nt= size(nodes,1); scale= scale/(sqrt(nt)*max(abs(u)));
xmin= min(coord(:,1))-0.1; xmax= max(coord(:,1))+0.1;
ymin= min(coord(:,2))-0.1; ymax= max(coord(:,2))+0.1;
axis([xmin xmax ymin ymax]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot gradients on triangular or rectangular mesh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch size(nodes,2)
case 3
   for t=1:nt
      nloc= nodes(t,:); xloc= coord(nloc,:); xmid= sum(xloc)/3;
      areat= det([(xloc(2,:)-xloc(1,:))',(xloc(3,:)-xloc(1,:))'])/2;
      gradu=  u(nloc(1))*(xloc(3,:)-xloc(2,:)) ...
             +u(nloc(2))*(xloc(1,:)-xloc(3,:)) ...
             +u(nloc(3))*(xloc(2,:)-xloc(1,:));
      gradu= gradu*[0 1; -1 0]/(2*areat);
      quiver(xmid(1),xmid(2),gradu(1),gradu(2),scale);
   end;
case 4
   for t=1:nt
      %%% local data for four triangles
      nloc= nodes(t,:); uloc= u(nloc); xloc= coord(nloc,:);
      um= sum(uloc)/4; xm= sum(xloc)/4;
      for l=1:4
         uloc2= [uloc(zykle(l)),uloc(zykle(l+1)),um];
         xloc2= [xloc(zykle(l),:);xloc(zykle(l+1),:);xm];
         xmid = sum(xloc2)/3;
         areat= det([(xloc2(2,:)-xloc2(1,:))',(xloc2(3,:)-xloc2(1,:))'])/2;
         gradu=  uloc2(1)*(xloc2(3,:)-xloc2(2,:)) ...
                +uloc2(2)*(xloc2(1,:)-xloc2(3,:)) ...
                +uloc2(3)*(xloc2(2,:)-xloc2(1,:));
         gradu= gradu*[0 1; -1 0]/(2*areat);
         quiver(xmid(1),xmid(2),gradu(1),gradu(2),scale);
      end;
   end;
otherwise
   error('*** ERROR *** case not implemented');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title('gradient');
grid off; axis equal;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%