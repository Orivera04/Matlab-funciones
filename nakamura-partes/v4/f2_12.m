% f2_12 same as L2_17
% Illustrates 2D plot.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.12; List 2.17')

clear,clf
t=0:0.1:20;
r= exp(-0.2*t);
th=pi*t*0.5;
z=t;
x=r.*cos(th);
y=r.*sin(th);
plot3(x,y,z)
hold on
plot3([1,1], [-0.5,0], [0,0])
text( 1,-0.7,0, 'A')
n=length(x);
text( x(n),y(n),z(n)+2,'B')
xlabel('X'); ylabel('Y'); zlabel('Z');

