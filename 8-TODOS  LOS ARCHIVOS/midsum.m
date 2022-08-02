function quad = midsum ( f, a, b, n )

%  function quad = midsum ( f, a, b )
%
%  Return the value of a composite midpoint rule using N points 
%  (and N-1 intervals) to approximate the integral from A to B of F(X).  
%
  h = ( b - a ) / ( n - 1 );
  x = linspace ( a, b, n );
  x = 0.5 * ( x(1:n-1) + x(2:n) );
  fvec = feval ( f, x );

  quad = h * sum ( fvec );




