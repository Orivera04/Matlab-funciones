[xx, yy, zz] = cylinder([0 1 2 3 4 3 2 1 0],50); 
subplot(1,3,1); surf(xx,yy,zz); colormap(gray); 
shading flat; axis off; campos(campos+1);camlight local
subplot(1,3,2); surf(xx,yy,zz); colormap(gray); shading flat; 
camproj perspective; axis off; campos(campos+1);camlight local
subplot(1,3,3);surf(xx,yy,zz); colormap(gray);
camproj perspective; axis off; camlight infinite; 
shading interp; campos(campos+1)

