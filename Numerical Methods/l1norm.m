function value = l1norm ( f, a, b )

N = 101;
h = ( b - a ) / (N - 1);

x = linspace ( a, b, N );
fx = abs ( feval ( f, x ) );
%
%  Add all the terms, and subtract off half the end values.
%
value = sum ( fx ) - 0.5 * fx(1) - 0.5 * fx(N);

value = h * value;
