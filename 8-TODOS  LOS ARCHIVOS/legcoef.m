function coef = legcoef ( n, f )
%
%  function coef = legcoef ( n, f )
%
%  Compute the coefficients 0 to N of the Legendre polynomial expansion of F.
%  The result COEF will be a COLUMN vector of length N+1.
%
nval = 201;
h = 2 / ( nval - 1 );

xvec = linspace ( -1, 1, nval );
fvec = feval ( f, xvec );

for i = 0 : n
%
%  Compute the value of the I-th normalized Legendre polynomial.
%
  pvec = legpoly ( i, xvec );
%
%  FVEC is a row vector because XVEC is a row vector because that's
%    what LINSPACE returns.
%
%  PVEC is a row vector because XVEC is a row vector and LEGPOLYN1 returns
%    something of the same shape as what it gets.
%
%  THEREFORE, we have to use the TRANSPOSE operator on the first
%  vector to get a scalar as our result.
%
  coef(i+1) = ( fvec * pvec' ) * h;

end

