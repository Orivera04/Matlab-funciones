 % create 10-point convex polyhedron:
 k=0;
 while length(unique(k))<10
 x=rand(10,1);
 y=rand(10,1);
 z=rand(10,1);
 k=convhulln([x y z]);
 end
 P=[x y z]; % polyhedron points
 C=centroid(P);
 close all
 fn=figure;hold on;axis equal;grid on
 plot3(x,y,z,'b.','markersize',20)
 for m = 1:length(k)
     f = k(m,:);
 patch(x(f),y(f),z(f),'g','facealpha',.5)
 end
 plot3(C(1),C(2),C(3),'r.','markersize',24)
 view(45,45)
 axis vis3d
 set(gca,'xticklabel','','yticklabel','','zticklabel','')
 for az=45:5:405
     if ~ishandle(fn)
         break
     end
     view(az,45)
     drawnow
     pause(.1)
 end
