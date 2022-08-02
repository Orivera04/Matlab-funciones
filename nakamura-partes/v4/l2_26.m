% L2_26 plots Figure 2.26.
% Copyright S. Nakamura 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.26')

clear,clf,hold off
dth=pi/20;
j=1:21;
i=1:10;
x = log(i);
y = log(j);
[x,y] = meshgrid(x,y);
z=sqrt(0.1*((x-log(5)).^2 + (y-log(5)).^2))+1;
meshc(x,y,z)
xlabel('x')
ylabel('y')
zlabel('z')

