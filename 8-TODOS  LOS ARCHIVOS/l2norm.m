function value = l2norm ( f, a, b )

N = 101;
h = ( b - a ) / (N - 1);

x = linspace ( a, b, N );
fx = feval ( f, x );
fx = fx.^2;
%
%  Add all the terms, and subtract off half the end values.
%
value = sum ( fx ) - 0.5 * fx(1) - 0.5 * fx(N);

value = sqrt ( h * value );
