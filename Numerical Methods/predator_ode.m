function yprime = predator_ode ( x, y )
%
%  function yprime = predator_ode ( x, y )
%
%  computes the derivative for the predator-prey ODE.
%
yprime = [ 1.0 - 0.5 * y(2);
        - 0.75 + 0.25 * y(1) ];

