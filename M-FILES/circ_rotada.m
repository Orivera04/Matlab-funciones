%circunferencia rotada
t=0:pi/100:2*pi;
x=cos(t);
y=sin(t);
%plot(x,y);axis([-2 2 -2 2])
hold on;
theta=pi/2;Lx=0;Ly=0;
[Xrt,Yrt]=traslarota(theta,Lx,Ly,x,y)
plot(Xrt,Yrt);axis([-1.5 1.5 -1.5 1.5])