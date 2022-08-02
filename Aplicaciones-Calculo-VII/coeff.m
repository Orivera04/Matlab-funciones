function b=coeff(n)
%b = zeros(1,n - 1);
for i=1:n+1
  %b(i) = a(i) + a(i + 1)
  b(i) = nchoosek(n,i-1);
end
b