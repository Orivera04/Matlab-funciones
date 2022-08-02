THETA=0:pi/12:2*pi;
 Z=-2:.1:2;
 [z,theta]=meshgrid(Z,THETA);
 r=z;
 x=r.*cos(theta);
 y=r.*sin(theta);
 mesh(x,y,z)