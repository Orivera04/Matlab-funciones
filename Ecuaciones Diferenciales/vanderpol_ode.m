function yprime = vanderpol_ode ( x, y )
%
%  function yprime = vanderpol_ode ( x, y )
%
%  computes the derivative for the van der Pol ODE:
%
%  y'' + ( y^2 - 1 ) * y' + y = 0.
%
%  Try integrating from 0 to 20 with initial condition [ 0;0.25].
%
yprime = [ y(2);
          - ( y(1)^2 - 1 ) * y(2) - y(1) ];

