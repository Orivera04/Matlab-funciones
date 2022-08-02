function yprime = pendulum_nonlinear_ode ( x, y )
%
%  function yprime = pendulum_nonlinear_ode ( x, y )
%
%  computes the derivative for the nonlinear pendulum ODE.
%
temp = sin ( y(1) );
yprime = [ y(2); - 1.5 * temp ];

