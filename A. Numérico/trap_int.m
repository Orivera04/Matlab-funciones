function value = trap_int ( a, b, fvec )
%
%  function value = trap_int ( a, b, fvec )
%
%  Retorna el valor de la aproximación trapezoidal a la
%  integral desde a a b de f(x).  
%
%  Se supone que fvec contiene valores de f en puntos 
%  igualmente espaciados de a a b.
%
n = length ( fvec );

s = sum ( fvec ) - 0.5 * ( fvec(1) + fvec(n) );

integral = (( b - a ))/(n-1) * s




