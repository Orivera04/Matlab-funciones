function yprime = stiff_ode ( x, y )
%
%  function yprime = stiff_ode ( x, y )
%
%  computes the derivative for the stiff ODE:
%
%    Y' = - 5 * Y
%
yprime = - 5.0 * y;

