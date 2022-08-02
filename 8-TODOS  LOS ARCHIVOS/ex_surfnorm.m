x =linspace(-1,1,21);  [xx,yy] = meshgrid(x); 
z = 1-(xx.*xx+yy.*yy);
subplot(1,3,1); surface(xx,yy,z); colormap(gray); shading interp
subplot(1,3,[2 3]); surfnorm(xx,yy,z); colormap(gray); shading interp
