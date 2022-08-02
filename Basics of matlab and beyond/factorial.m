function y = factorial(x)

if x==0
  y = 1;
else
  [m,n] = size(x);
  y = zeros(size(x));
  for i=1:m
    for j=1:n
      y(i,j) = prod(1:x(i,j));
    end
  end
end