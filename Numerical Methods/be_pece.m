function [ x, y ] = be_pece ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = be_pece ( f, x_range, y_initial, nstep )
%
%  BE_PECE uses NSTEP steps of the backward Euler PECE method to 
%  estimate Y, the solution of an ODE, at the equally spaced points X in the 
%  range X_RANGE(1) to X_RANGE(2).  
%
%  One step of the predictor, Euler's forward method,
%  is followed by one step of the corrector, Euler's backward method.
%
%  The name of the derivative function is F. 
%
x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;

for i = 1 : nstep
  x(i+1) = x(i) + dx;
  yp = y(:,i) + dx * feval ( f, x(i), y(:,i) );
  y(:,i+1) = y(:,i) + dx * feval ( f, x(i+1), yp );
end
