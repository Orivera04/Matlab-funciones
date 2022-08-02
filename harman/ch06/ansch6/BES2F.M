function xdot=bes2f(t,x,flag,a,b)
%  CALL: xdot=bes2f(t,x,flag,a,b); Called by ode23. This function defines the second
%    order differential equation y''+b*exp(at)y = 0. flag is a dummy variable.
%           
%  The equation set is y''+b*exp(at)y = 0 using x1 = y  x2= y'
xdot = [0 1; - b*(exp(a*t)) 0]*x;
% xdot(1) = 0*x(1) + x(2);
% xdot(2) = - b*(exp(a*t))*x(1) ;
%
% Version 5 Output column vector



