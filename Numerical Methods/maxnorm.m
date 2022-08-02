function value = maxnorm ( f, a, b )

N = 101;

x = linspace ( a, b, N );
fx = feval ( f, x );
value = max ( abs ( fx ) );


