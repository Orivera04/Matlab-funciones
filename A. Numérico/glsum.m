function quad = glsum ( f, a, b, n )
%
%  function quad = glsum ( f, a, b, n )
%
%  Return the value of the (simple) N-th order Gauss-Legendre approximation to 
%  the integral from A to B of F(X).  
%
h = ( b - a ) / 2;
x = gl_space ( a, b, n );
wvec = gl_weight ( n );
fvec = feval ( f, x );
quad = h * wvec' * fvec;




