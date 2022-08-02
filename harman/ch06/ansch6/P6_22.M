% P6_22.M  Plot J0 and J1 and find zeros
%
clear
x=[0:0.1:15];
plot(x,besselj(0,x),'-',x,besselj(1,x),'--')
title('Bessel function J0 and J1')
xlabel('x')
ylabel('J(x)')
grid
legend('J0','J1')
%
% The zeros may be found in several ways including estimating
% the value from the graph using the zoom command. Try fzero command. 
%
% Note: mouse clicks for zoom and legend may conflict 
