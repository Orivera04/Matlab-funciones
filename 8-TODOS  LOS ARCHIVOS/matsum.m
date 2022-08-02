function quad = matsum ( f, a, b, n )
%
%  function value = matsum ( f, a, b, n )
%
%  Return the value of a crude approximation to the
%  integral from A to B of F(X) that uses N evenly spaced points.
%
h = ( b - a ) / ( n - 1 );
xvec = linspace ( a, b, n );
fvec = feval ( f, xvec );

quad = h * sum ( fvec );




