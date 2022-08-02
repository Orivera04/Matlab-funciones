
function mu = wsft(A)

% Wilkinson's shift mu of the symmetric matrix A.

[n, n] = size(A);
if A == diag(diag(A))
   mu = A(n,n);
   return
end
mu = A(n,n);
if n > 1
   d = (A(n-1,n-1)-mu)/2;
   if d ~= 0
      sn = sign(d);
   else
      sn = 1;
   end
  bn = A(n,n-1);
  mu = mu - sn*bn^2/(abs(d) + sqrt(d^2+bn^2));
end

