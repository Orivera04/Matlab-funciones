function fy = stiff_ode_partial ( x, y )
%
%  function fy = stiff_ode_partial ( x, y )
%
%  computes the partial derivative with respect to Y of the right hand side 
%  for the stiff ODE:
%
%    Y' = - 5 * Y
%
fy = - 5.0;

