function p = primes(n)
%PRIMES Generate list of prime numbers.
%   P = PRIMES(N) is a row vector of the prime numbers less than or 
%   equal to N.  A prime number is one that has no factors other
%   than 1 and itself.  This file is used as an example
%   for the MATLAB Excel Builder product.
%
%   See also FACTOR, ISPRIME.

%   Copyright (c) 2001 The MathWorks, Inc. 
%   $Revision: 1.1 $     $Date: 2001/11/27 20:41:37 $

if length(n)~=1, error('N must be a scalar'); end
if n < 2, p = zeros(1,0); return, end
p = 1:2:n;
q = length(p);
p(1) = 2;
for k = 3:2:sqrt(n)
  if p((k+1)/2)
     p(((k*k+1)/2):k:q) = 0;
  end
end
p = p(p>0);

