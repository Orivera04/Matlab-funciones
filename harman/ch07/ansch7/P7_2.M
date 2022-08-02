% P7_2.M  Least squares fit of a line to data
%
x=[6.1 7.6 8.7 10.4];
y=[0 2 4 6];
%
A1=[1 1 1 1];
A=[A1' x'];
fprintf('Coefficients')
xlsq=A'*A \ A'*y'
%
fprintf('Equation: %fx  %f\n',xlsq(2),xlsq(1));
%
xplot=[6.1:0.01:10.4];
yplot=xlsq(2).*xplot + xlsq(1);
plot(x,y,'o',xplot,yplot,'-')
title('Least squares line for spring')
%
% Add a few comments and annotate plot.
%