function outprod = prodMToNii(m,n)
% prodMToNii returns the product of m:n 
%  using : and prod
% Format: prodMToNii(m,n) or profMToNii(n,m)

if m < n
   outprod = prod(m:n);
else
    outprod = prod(m:-1:n);
end
end
