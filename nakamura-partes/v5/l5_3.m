% L5_3.  See Example 5.3.
% Copyright S. Nakamura, 1995
clear
Iexact = 4.006994;
a = 0; b=2;
fprintf('\n Extended Simpson 1/3 Rule\n');
fprintf('  n         I        Error\n');
n = 1;
for k=1:4,   n = 2*n;
  h = (b-a)/n;   i = 1:n+1;
  x = a + (i-1)*h;   f = sqrt(1 + exp(x));
  I =   (h/3)*( f(1)+ 4*sum(f(2:2:n)) + f(n+1));
  if n>2, I = I+ (h/3)*2*sum(f(3:2:n)); end
  fprintf('%3.0f %10.5f   %10.5f\n', n,I,Iexact-I);
end

