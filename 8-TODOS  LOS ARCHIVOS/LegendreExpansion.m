
% LegendrePolyExpansion.m by David Terr, Raytheon, 5-26-04

% Given a polynomial f(x) of degree n expressed as a row vector of coefficients of x^k with
% highest power on the left, expand f(x) as a sum of scalar multiples of
% Legendre polynomials, i.e. return the column vector of coefficients a_k with k
% running from n to 0 from top to bottom such that f(x) = sum_{k=0}^n{a_k P_k(x)}.

% Compute the coefficients of the Legendre expansion of f(x).
function coeffs = LegendreExpansion(f)
n = length(f) - 1;
M = LegendrePolyMatrix(n);
coeffs = inv(M)*f(n+1:-1:1);
coeffs = coeffs(n+1:-1:1);

% For given nonnegative integer n, compute the (n+1)x(n+1) matrix whose (k+1)st
% column contains the Taylor coefficients of P_k(x), starting with the
% constant term.
function M = LegendrePolyMatrix(n)

if n==0 
    M = 1;
    return;
elseif n==1
    M = [1 0; 0 1];
    return;
else
    M = zeros(n+1);
    M(1,1) = 1;
    M(2,2) = 1;

    for k=1:n-1
        M(:,k+2) = ((2*k+1)*[0; M(1:n,k+1)] - k*M(:,k))/(k+1);
    end
end
