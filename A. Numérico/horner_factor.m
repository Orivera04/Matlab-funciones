function [ b, rem ] = horner_factor ( c, r1 )
%
%  HORNER_FACTOR rewrites a polynomial from the form
%      c(1)*x^(n-1) + c(2) * x^(n-2) + ... + c(n-1)   * x      + c(n)
%  to the form
%    ( b(1)*x^(n-2) + b(2) * x^(n-1) + ... + b(n-1) ) * (x-r1) + rem
%
n = size ( c, 2 );

if ( n == 1 )
  b = []
  rem = c(1)
else
  b(1) = c(1);
  for i = 2: n -1
    b(i) = c(i) + r1 * b(i-1);
  end
  rem = c(n) + r1 * b(n-1);
end
