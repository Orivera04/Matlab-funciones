function c = fitpoly ( x, y )

n = size ( x, 2 );

for i = 1 : n
  for j = 1 : n
    A(i,j) = x(i)^(n-j);
  end
end

c = A \ y';

