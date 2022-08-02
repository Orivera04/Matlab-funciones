function xdot=mx3ordpf(t,x,flag,a1,a2,a3,foft);
%  CALL: xdot=mx3ordpf(t,x,flag,a1,a2,a3,foft)
%  Called by ode23.  This function defines the third
%    order differential equation as xdot=Ax.
%  t is a scalar input and x is solution from ode23.m 
%  variables a1, a2, a3 and foft defined by input in P5_18.M
%
%  The equation set  y'''+a1*y''+a2*y'+a3*y = f(t) 
%   using x1 = y  x2= y'
%
xdot(1) = 0*x(1) + x(2) + 0*x(3);
xdot(2) = 0*x(1) + 0*x(2) + x(3);
xdot(3) = - a3*x(1) -a2*x(2) - a1*x(3) + eval(foft);
xdot=xdot';            % Form column vector 
%
% The formulation of xdot=Ax can be simplified. In fact, 
%  write it as xdot=Ax and pass A to the function


