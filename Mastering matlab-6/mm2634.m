[x,y,z,v] = flow(13);              % get flow data
fv = isosurface(x,y,z,v,-2);       % find surface of value -2
subplot(1,2,1)
p = patch(fv);                     % plot -2 surface
set(p,'FaceColor',[.5 .5 .5],'EdgeColor','Black'); % modify patches
view(3),axis equal tight, grid on  % pretty it up
title({'Figure 26.34a:' 'Isosurface Plot, V = 2'})
subplot(1,2,2)
p = patch(shrinkfaces(fv,.3));     % shrink faces to 30% of original 
set(p,'Facecolor',[.5 .5 .5],'EdgeColor','Black'); % modify patches
view(3),axis equal tight, grid on
title({'Figure 26.34a:' 'Shrunken Face Isosurface Plot, V = 2'})
