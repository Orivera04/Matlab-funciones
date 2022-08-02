function runprod = prodMToN(m,n)
% prodMToN returns the product of m:n 
%   using a for loop
% Format: prodMToN(m,n) or prodMToN(n,m)

% Make sure m is less than n
if m > n
   temp = m;
   m = n;
   n = temp;
end

% Loop to calculate the running product
runprod = 1;
for i = m:n
   runprod = runprod * i;
end
end
