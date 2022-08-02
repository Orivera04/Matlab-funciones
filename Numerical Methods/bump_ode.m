function yprime = bump_ode ( x, y )
%
%  function yprime = bump_ode ( x, y )
%
%  computes the derivative for the bump ODE:
%
%    Y' = -Y^2
%
%  whose solution, given y(0) = 1, is y(x) = 1 / ( 1 + x ).
%
yprime = - y * y;

