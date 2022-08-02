function result = cmuller ( f, x0, x1, x2 )
%
%  CMULLER carries out Muller's method for seeking a (possibly complex) 
%  root of a nonlinear function.
%  This is a "stripped down" version with little error checking.
%
  FATOL = 0.00001;
  XRTOL = 0.00001;
  ITMAX = 10;

  y0 = feval ( f, x0);
  y1 = feval ( f, x1);
  y2 = feval ( f, x2);

  it = 0;

  format long

  while ( it <= ITMAX ) 

    it = it + 1;
%
%  Determine the coefficients 
%    A, B, C 
%  of the polynomial 
%    Y(X) = A * (X-X2)**2 + B * (X-X2) + C
%  which goes through the data:
%    (X1,Y1), (X2,Y2), (X3,Y3).
%
  a = ( ( y0 - y2 ) * ( x1 - x2 ) - ( y1 - y2 ) * ( x0 - x2 ) ) / ...
        ( ( x0 - x2 ) * ( x1 - x2 ) * ( x0 - x1 ) );

  b = ( ( y1 - y2 ) * ( x0 - x2 )^2 - ( y0 - y2 ) * ( x1 - x2 )^2 ) / ...
    ( ( x0 - x2 ) * ( x1 - x2 ) * ( x0 - x1 ) );

  c = y2;
%
%  Get the roots of the polynomial.
%
  if ( a ~= 0 )

    disc = b * b - 4.0 * a * c;
         
    q1 = ( b + sqrt ( disc ) );
    q2 = ( b - sqrt ( disc ) );

    if ( abs ( q1 ) < abs ( q2 ) )
      dx = - 2.0 * c / q2;
    else
      dx = - 2.0 * c / q1
    end

  elseif ( b ~= 0 )
    dx = - c / b;
  else
    '(Muller algorithm broke down, results unreliable.)'
    result = x2;
    return
  end

  x3 = x2 + dx;

  x0 = x1;
  x1 = x2;
  x2 = x3;

  y0 = y1;
  y1 = y2;
  y2 = feval ( f, x2);

  [ x2, y2 ]
%
%  Declare victory if the most recent change in X is small, and 
%  the size of the function is small.
%
  if ( abs ( dx ) < XRTOL * ( abs ( x2 ) + 1.0 ) & abs ( y2 ) < FATOL ) 
    result = x2;
    return
  end

end

result = x2;

'(Maximum number of iterations taken, results unreliable.)'


