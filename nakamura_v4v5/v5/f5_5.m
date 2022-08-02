% f5_5 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.5')

clear clf,hold off
p0=[-6,0];
p1=[0,6];
%axis([-6,6,-2,6])
plot([-5,5], [0,0]), hold on
plot([0,0],[0,5])
text(2,-1.2,'x','FontSize', [18])
text(0.2,5.5,'y','FontSize', [18])

text(5.2,0,'+inf','FontSize', [18])
text(-6.3,0,'-inf','FontSize', [18])
text(1,2,'f(x)','FontSize', [18])
x=-4.5:0.05:4.5;  a=-0.2;
y=3*exp(-x.^2).*(1+ sin(3*x)/1.5);
plot(x,y)

plot([3.5 3.5],[0 1])
plot([-3.5 -3.5],[0 1])
text(3.2,-0.6,'x=X','FontSize', [18])
text(-4.0,-0.6,'x=-X','FontSize', [18])

axis([-6,6,-1.2,5.2])
axis('off')
%print fig5_5.ps


