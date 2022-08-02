function[Xrt,Yrt]=traslarota(theta,Lx,Ly,x,y)
a = [cos(theta) -sin(theta); sin(theta) cos(theta)];
Xrt = a(1,1)*x+a(1,2)*y+Lx;
Yrt = a(2,1)*x+a(2,2)*y+Ly;