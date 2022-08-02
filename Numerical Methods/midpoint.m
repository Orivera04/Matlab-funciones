function [ x, y ] = midpoint ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = midpoint ( f, x_range, y_initial, nstep )
%
%  MIDPOINT uses NSTEP steps of the midpoint method to estimate Y, 
%  the solution of an ODE, at the equally spaced points X in the range 
%  X_RANGE(1) to X_RANGE(2).  The name of the derivative function is F. 
%
%  The midpoint method requires an estimate for the solution at the
%  first time step.  Here, we use either Euler's method or
%  Euler's halfstep method to get the value at the first time step.
%
%  The midpoint method is unstable.
%
x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;
%
%  On the first step...
%
i = 1;
  x(i+1) = x(i) + dx;
%
%  ...take an Euler step, or
%
  y(:,i+1) = y(:,i) + dx * feval ( f, x(i), y(:,i) );
%
%  ...take a more accurate Euler halfstep.
%
% xhalf = x(i) + 0.5 * dx;
% yhalf = y(:,i) + 0.5 * dx * feval ( f, x(i), y(:,i) );
% y(:,i+1) = y(:,i) + dx * feval ( f, xhalf, yhalf );
%
%  All the other steps use the midpoint method.
%
for i = 2 : nstep
  x(i+1) = x(i) + dx;
  y(:,i+1) = y(:,i-1) + 2.0 * dx * feval ( f, x(i), y(:,i) );
end
