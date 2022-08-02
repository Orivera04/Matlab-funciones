% P5_18.M To compute solution of y'''+a1*y''+a2*y'+a3*y=f(t) and plot y(t)
%  Input coefficients  a1  a2 a3 and function f 
% Calls ode23 and mx3ordf
%
% Pass a1 a2 a3 foft to function mx3ordf
%
fprintf('Solve D3y+a1*D2y+a2*DY+a3*y=f(t)\n')
fprintf('Output is vector t (time) and state vector x\n')
fprintf('y(t) = x(:,1), dy(t)=x(:,2), d2y(t)=x(:,3) - Strike a key to continue\n')
pause
%
a1=input('Input a1=  ');
a2=input('Input a2=  ');
a3=input('Input a3=  ');
%  Define f(t) and time of plot and initial values
%    f(t) is input as function, i.e. exp(t)
foft=input('Input f(t) ','s');
t0=input('Initial time for equation =  ');
tf=input('Final time=  ');
x0=input('[y(0) Dy(0) D2y(0)] =  ');
x0t=x0';
%
% Calls function mx3ordf several times for each t to define equations.
[t,x]=ode23('mx3ordf',[t0,tf],x0t,[],a1,a2,a3,foft);     
% Output is two vectors ([t, x'] in program)
% y values
y=x(:,1);
dy=x(:,2);
d2y=x(:,3);
% Annotate the graph
title_x=input('Title =  ', 's')
xlabel_1=input('xlabel =  ','s')
ylabel_1=input('ylabel =  ','s')
%
plot(t,y)       % Plot the solution
title(eval('title_x'))
xlabel(eval('xlabel_1'))
ylabel(eval('ylabel_1'))
grid

