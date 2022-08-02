function pval = legpoly0 ( n, x )
%
%  PVAL is the value of the N-th Legendre polynomial at X.
%  Assume that X is a scalar.
%
if ( n < 0 ) 
  pval = 0;
elseif ( n == 0 )
  pval = 1;
elseif ( n == 1 )
  pval = x;
else 
  p1 = 1;
  p2 = x;
  for i = 2 : n
    p0 = p1;
    p1 = p2;
    p2 = ( ( 2*i-1) * x * p1 - ( i - 1 ) * p0 ) / i;
  end
  pval = p2;
end
