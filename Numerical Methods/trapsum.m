function quad = trapsum (a,b,n,f)
%
%  La functión quad = trapsum ( a, b, fvec )
%  retorna el valor aproximado de la integral de f(x) de 'a' a 'b' 
%  usando n puntos de evaluación y por tanto n-1 subintervalos.   
%
h = ( b - a ) / ( n - 1 );
x = linspace ( a, b, n );
fvec = feval ( f, x );
quad = h * ( sum ( fvec) - 0.5 * ( fvec(1) + fvec(n) ) );




