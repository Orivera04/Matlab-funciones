% P7_10.M Compute and plot a least squares polynomial of degree n
%  given N data points
%
clear
x=input('Enter x values [x1 x2 ...] '); disp(x)
y=input('Enter y values [x1 x2 ...] '); disp(y)
n=input('Enter polynomial degree n= '); disp(n)
%
xlsq=polyfit(x,y,n);
fprintf('Least-squares coefficients:\n');disp(xlsq)
%
xplot=[min(x):(max(x)-min(x))/1000:max(x)];
f=polyval(xlsq,xplot);
plot(x,y,'o',xplot,f,'-')
title(['nth order least squares fit, n=', num2str(n)])
xlabel('x')
ylabel('y')
grid
