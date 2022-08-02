function pvec = legval ( c, x )
%
%  function pvec = legval ( c, x )
%
%  Evaluate at X the Legendre polynomial approximation  whose coefficients are C.
%
n = length ( c ) - 1;
pvec = zeros ( size ( x ) );
for i = 0 : n
  p = legpoly ( i, x );
  pvec = pvec + p * c(i+1);
end

