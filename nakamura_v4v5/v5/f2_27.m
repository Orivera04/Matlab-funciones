% f2_27 same as L2_27 plots Figure 2.27.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.27')

clear,clf,hold off
dth=pi/20;
for j=1:21
for i=1:10
r=0.5+0.2*i + j*0.01*i;
th = dth*(j-1);
x(i,j) = r*cos(th);
y(i,j)= r*sin(th);
z=cos(0.1*(x.^2 + y.^2))+1;
end
end
mesh(x,y,z) % plotting a mesh
view(0,90)
xlabel('x')
ylabel('y')
zlabel('z')
axis([-5, 4, -1 , 5 ])
view([-135,40])
hold on
mesh(x,y,zeros(size(x))) % plotting a grid on x-y plane
disp 'Hit Return'
pause
surf(x,y,z) 
hold off
