function x = cheby_points ( a, b, n )

i = 1:n;

theta = ( 2 * i - 1 ) * pi / ( 2 * n );

x = 0.5 * ( a + b + (a-b) * cos ( theta ) );
