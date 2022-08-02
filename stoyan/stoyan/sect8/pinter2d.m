% © Gergo Lajos 1998
 x=rand(20,1); y=rand(20,1); x=5.*x; y=5.*y;
 z=x.*sin(1+y.^2);
 a=0:0.1:5;
 [xi,yi]=meshgrid(a);
 zi=griddata(x,y,z,xi,yi);
 mesh(xi,yi,zi);
 hold;
 plot3(x,y,z,'o');