function pvec = legpoly ( i, x )
%
%  function pvec = legpoly ( i, x )
%
%  Evaluate the I-th NORMALIZED Legendre polynomial at X.
%  X may be a vector of points.
%  The output PVEC will have the same shape as X.
%
nx = length ( x );
%
%  Compute the value of the I-th unnormalized Legendre polynomial.
%
if ( i < 0 )
  pvec = zeros ( size ( x ) );
  return;
elseif ( i == 0 )
  pvec = ones ( size ( x ) );
elseif ( i == 1 ) 
  pvec = x;
else
  p1 = ones ( size ( x ) );
  p2 = x;
  for j = 2 : i
    p0 = p1;
    p1 = p2;
    p2 = ( ( 2*j-1) * x .* p1 - ( j - 1 ) * p0 ) / j;
  end
  pvec = p2;
end
%
%  Normalize.
%
pvec = sqrt ( 0.5 * ( 2 * i + 1 ) ) * pvec;

