% EX10_7.M Plot Taylor series approximation and
%  function f(x,y)= sqrt(1+x^2+y^2); Input y value.
clear              % Clear variables
clf                %  and figures
x=[-2:0.2:2];
y=input('Input y value= ')
z1=x.^2+y.^2;      % Quadratic terms
Z=sqrt(1+z1);      % Function
ztay=1+z1/2;       % Taylor approximation
% Plot the two graphs in one figure
plot(x,ztay,'-')   % Dotted lines
hold               % Plot on same axis
plot(x,Z,'--')
legend('f(x,y)','Taylor Approx')
title(['Approximation of z=sqrt(1+x^2+y^2), ',...
' y=',num2str(y)])
xlabel('x')
ylabel('z')
zoom                % Change resolution with mouse
