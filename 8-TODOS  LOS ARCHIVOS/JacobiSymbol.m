% Compute the Jacobi symbol (a/b). When b=p is prime, this is equal to the
% Legendre symbol, which is 1 if a is a quadratic residue modulo p, -1 if
% it is a quadratic nonresidue modulo p, and 0 if a divides p.

function js = JacobiSymbol(a, b)