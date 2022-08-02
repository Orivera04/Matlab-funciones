x =linspace(-1,1,31); [xx,yy]=meshgrid(x); z=1-(xx.*xx+yy.*yy);
h=surface(xx,yy,z); colormap(gray); shading interp