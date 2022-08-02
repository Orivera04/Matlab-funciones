% P5_14.M Solve the equation D2y-4*Dy+3*y = f(x)
%   for f(x)=0 and f(x)=10*exp(-2x)
%  (Requires Symbolic Math Toolbox)
%   Uses gtext command to annotate curves
%
y1=dsolve('D2y-4*Dy+3*y=0','y(0)=1','Dy(0)=-3','x')
%
tf=1.0
clf
hold on
ezplot(y1,[0,tf]);	
gtext('f(x)=0')
pause
y2=dsolve('D2y-4*Dy+3*y=10*exp(-2*x)','y(0)=1','Dy(0)=-3','x')
ezplot(y2,[0,tf])
gtext('f(x)=10*exp(-2x)')
title('Solution to D2y-4*Dy+3*y=f(x)')
ylabel('y(t)')
zoom
hold off
%
% Comment
%
% Comparing the analytic solution with dsolve and the numerical
%  solution using 0de23 shows that the error in the numerical
%  result increases rapidly for x > 8.
% 
%
% Version 5  change call to ezplot  [0,1]

 