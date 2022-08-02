
% File ODEsys for finding numerical and exact solutions
% to the system of differential equations
% y1'=-30*y1-29*y2; y2'=-29*y1-30*y2 with the initial conditions
% y1(0) = 2, y2(0) = 0.
% Symbolic Math Toolbox must be installed.

f = inline('-[30 29;29 30]*y','t','y');
[t,y] = ode45(f,[0 1],[2 0]);
plot(t,y(:,1),t,y(:,2),'--')
legend('y1','y2')
title('Numerical solutions y_1 and  y_2')
xlabel('t')
pause (5)
figure
[y1,y2] = dsolve('Dy1=-30*y1-29*y2','Dy2=-29*y1-30*y2',...
   'y1(0)=2','y2(0)=0')
exact = [subs(y1,t) subs(y2,t)];
plot(t,y(:,1)-exact(:,1),'-',t,y(:,2)-exact(:,2),'--')
legend('e1','e2')
title('Errors e_1 = y_1- exact y_1  and  e_2 = y_2 - exact y_2')
