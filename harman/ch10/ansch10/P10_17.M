% P10_17.M Determine the extrema of the function
% f(x,y) = x^3-12*x*y+8*y^3
%
clear
clf
format long
%
fxy='(x(1)^3)-(12*x(1)*x(2))+(8*x(2)^3)';
x0=[1 1];
xmin=fmins(fxy,x0);
fprintf('Extrema at: %g, %g\n\n',xmin(1),xmin(2))
%
% Surface plot
%
x=xmin(1)-1.0:0.1:xmin(1)+1;
y=xmin(2)-1.0:0.1:xmin(2)+1;
[X,Y]=meshgrid(x,y);
fxy=X.^3-12*X.*Y+8*Y.^3;
surf(X,Y,fxy)
xlabel('x')
ylabel('y')
zlabel('f(x,y)')

