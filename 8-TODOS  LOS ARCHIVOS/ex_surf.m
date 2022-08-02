x =linspace(-1,1,29);  [xx,yy] = meshgrid(x); 
z = 1-(xx.*xx+yy.*yy);
subplot(1,3,1); h=surf(xx,yy,z); colormap(gray); shading interp
subplot(1,3,2); surfc(xx,yy,z); colormap(gray); shading interp
subplot(1,3,3);surfl(xx,yy,z); colormap(gray); shading interp