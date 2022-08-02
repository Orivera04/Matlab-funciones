function quad = ncsum ( f, a, b, n )
%
%  function quad = ncsum ( f, a, b, n )
%
%  Return the value of the (simple) N-th order Newton-Cotes approximation to the
%  integral from A to B of F(X).  
%
h = ( b - a ) / ( n - 1 );
x = linspace ( a, b, n );
wvec = nc_weight ( n );
fvec = feval ( f, x );
quad = h * wvec' * fvec;




