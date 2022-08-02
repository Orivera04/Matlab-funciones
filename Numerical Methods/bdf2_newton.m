function [ x, y ] = bdf2_newton ( f, fy, x_range, y_initial, nstep )
%
%  function [ x, y ] = bdf2_newton ( f, fy, x_range, y_initial, nstep )
%
%  BDF2_NEWTON uses NSTEP steps of the BDF2 Newton method 
%  to estimate Y, the solution of an ODE, at the equally spaced points X in 
%  the range X_RANGE(1) to X_RANGE(2).  
%
%  Euler's forward method is used as a predictor,
%  and Newton's method is used to seek a solution of the BDF2 formula.
%
%  The name of the derivative function is F. 
%  The name of the partial derivative function is FY.
%
TOL = 0.00001;

x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;
%
%  Do one BDF1 step.
%
i = 1;

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
%
%  All further steps are BDF2.
%
for i = 2 : nstep

  x(i+1) = x(i) + dx;
  yp = y(:,i) + dx * feval ( f, x(i), y(:,i) );

  it = 0;
  resmax = TOL + 1.0;

  while ( resmax > TOL & it < 10 ) 
    r = yp - ( y(:,i) + ( 1.0 / 3.0 ) * ( y(:,i) - y(:,i-1) + 2.0 * dx * feval ( f, x(i+1), yp ) ) );
    rprime = 1.0 - ( 2.0 / 3.0 ) * dx * feval ( fy, x(i+1), yp );
    yp = yp - r / rprime;
    resmax = max ( r );
    it = it + 1;
  end

  y(:,i+1) = yp;

end
