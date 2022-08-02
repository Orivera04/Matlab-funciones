function show_level(u,nodes,coord)
% Call: show_level(u,nodes,coord)
% Input:
%    u ... Nx1; Function values in the vertices
%    nodes,coord ... Description of the discretisation
% Graphical output:
%    Level lines on the discrete function 'u'

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Local definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc= zeros(3,1); uloc= zeros(3,1); xloc= zeros(3,2);
uloc2= zeros(3,1); xloc2= zeros(3,2); xm= zeros(2,1); um= zeros(2,1);
zykle= [1 2 3 4 1 2 3 4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prepare graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf;
hold on;
view(0,90);
nt= size(nodes,1);
xmin= min(coord(:,1))-0.1; xmax= max(coord(:,1))+0.1;
ymin= min(coord(:,2))-0.1; ymax= max(coord(:,2))+0.1;
axis([xmin xmax ymin ymax]);
umin= min(u); umax= max(u);
niveau= linspace(umin,umax,20);% 20 Level lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Loop over all elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch size(nodes,2)
case 3 %%% Case of triangulation
   for t=1:nt
      %%% local data
      nloc= nodes(t,:); uloc= u(nloc); xloc= coord(nloc,:);
      level_lines(uloc,xloc,niveau);
   end;
case 4 %%% Case of rectangular decomposition
   for t=1:nt
      %%% local data for four triangles
      nloc= nodes(t,:); uloc= u(nloc); xloc= coord(nloc,:);
      um= sum(uloc)/4; xm= sum(xloc)/4;
      for l=1:4
         uloc2= [uloc(zykle(l)),uloc(zykle(l+1)),um];
         xloc2= [xloc(zykle(l),:);xloc(zykle(l+1),:);xm];
         level_lines(uloc2,xloc2,niveau);
      end;
   end;
otherwise
   error('*** ERROR *** case not implemented');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title('level lines'); axis equal;
grid off;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function level_lines(uloc,xloc,niveau)
% Call: level_lines(uloc,xloc,niveau)
% Input:
%    uloc ... 3x1; Function values in the vertices
%    xloc ... 3x2; Vertices of the triangle
%    niveau ... 1xN; Level lines to draw
% Graphical output:
%    Level lines on the given triangle.
% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% local definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zykle= [1 2 3 1 2 3];
xx   = zeros(2,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% nothing to do for constant u
umin= min(uloc); umax= max(uloc);
if (umax-umin>1.e-6)
   %%% loop over all levels
   for l=1:size(niveau,2)
      univ= niveau(l);
      %%% check whether we have to do anything
      if (univ>umin & umax>univ)
         %%% search on each edge for two points
         ct= 0;
         for e=1:3
            ne= [zykle(e+1),zykle(e+2)];
            ue= uloc(ne);
            if (abs(ue(2)-ue(1))<1.e-6)
               if (abs(univ-ue(1))<1.e-6)
                  ct= ct+1; xx(ct,:)= xloc(ne(1),:);
                  ct= ct+1; xx(ct,:)= xloc(ne(2),:);
               end;
            else
               r= (univ-ue(1))/(ue(2)-ue(1));
               if (r>=0 & r<=1)
                  ct= ct+1;
                  xx(ct,:)= (1-r)*xloc(ne(1),:)+r*xloc(ne(2),:);
               end;
            end
            if (ct==2)
               if (univ>0)
                  plot([xx(1,1) xx(2,1)],[xx(1,2) xx(2,2)],'r-');
               elseif (univ<0)
                  plot([xx(1,1) xx(2,1)],[xx(1,2) xx(2,2)],'b-');
               else
                  plot([xx(1,1) xx(2,1)],[xx(1,2) xx(2,2)],'k-');
               end;
               break;
            end;
         end;
      end;
   end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%