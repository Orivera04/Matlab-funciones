[X,Y,Z,V] = flow;
fv = isosurface(X,Y,Z,V,-2);
subplot(2,2,1) % Original
p = patch(fv);
Np = size(get(p,'Faces'),1);
set(p,'FaceColor',[.5 .5 .5],'EdgeColor','Black');
view(3),axis equal tight, grid on  % pretty it up
zlabel(sprintf('%d Patches',Np))
title('Figure 26.35a: Original')

subplot(2,2,2) % Reduce Volume
[Xr,Yr,Zr,Vr] = reducevolume(X,Y,Z,V,[3 2 2]);
fvr = isosurface(Xr,Yr,Zr,Vr,-2);
p = patch(fvr);
Np = size(get(p,'Faces'),1);
set(p,'FaceColor',[.5 .5 .5],'EdgeColor','Black');
view(3),axis equal tight, grid on  % pretty it up
zlabel(sprintf('%d Patches',Np))
title('Figure 26.35b: Reduce Volume')

subplot(2,2,3) % Reduce Patch
p = patch(fv);
set(p,'FaceColor',[.5 .5 .5],'EdgeColor','Black');
view(3),axis equal tight, grid on  % pretty it up
reducepatch(p,.15) % keep 15 percent of the faces 
Np = size(get(p,'Faces'),1);
zlabel(sprintf('%d Patches',Np))
title('Figure 26.35c: Reduce Patches')

subplot(2,2,4) % Reduce Volume and Patch
p = patch(fvr);
set(p,'FaceColor',[.5 .5 .5],'EdgeColor','Black');
view(3),axis equal tight, grid on  % pretty it up
reducepatch(p,.15) % keep 15 percent of the faces 
Np = size(get(p,'Faces'),1);
zlabel(sprintf('%d Patches',Np))
title('Figure 26.35d: Reduce Both')
