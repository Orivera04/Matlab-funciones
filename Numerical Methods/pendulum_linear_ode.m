function yprime = pendulum_linear_ode ( x, y )
%
%  function yprime = pendulum_linear_ode ( x, y )
%
%  computes the derivative for the linear pendulum ODE.
%
yprime = [         y(2);
           - 1.5 * y(1) ];

