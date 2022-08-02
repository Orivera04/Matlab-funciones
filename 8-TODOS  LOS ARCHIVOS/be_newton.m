function [ x, y ] = be_newton ( f, fy, x_range, y_initial, nstep )
%
%  function [ x, y ] = be_newton ( f, fy, x_range, y_initial, nstep )
%
%  BE_NEWTON uses NSTEP steps of the backward Euler Newton method 
%  to estimate Y, the solution of an ODE, at the equally spaced points X in 
%  the range X_RANGE(1) to X_RANGE(2).  
%
%  Euler's forward method is used as a predictor,
%  and Newton's method is used to seek a solution of Euler's backward formula.
%
%  The name of the derivative function is F. 
%  The name of the partial derivative function is FY.
%
TOL = 0.00001;

x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;

for i = 1 : nstep

  x(i+1) = x(i) + dx;
  yp = y(:,i) + dx * feval ( f, x(i), y(:,i) );

  it = 0;
  resmax = TOL + 1.0;

  while ( resmax > TOL & it < 10 ) 
    r = yp - ( y(:,i) + dx * feval ( f, x(i+1), yp ) );
    rprime = 1.0 - dx * feval ( fy, x(i+1), yp );
    yp = yp - r / rprime;
    resmax = max ( r );
    it = it + 1;
  end

  y(:,i+1) = yp;

end
