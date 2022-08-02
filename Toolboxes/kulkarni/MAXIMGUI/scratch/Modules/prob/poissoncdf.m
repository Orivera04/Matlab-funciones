function y = poissoncdf(l,k)

% computes y(i) = P(X <= i-1) for i=1,...k+1, where X ~ Poisson(l) $rv. Range l \le 700.

y = poissonpmf(l,k);

for i=2:1:k+1
  y(i) = y(i-1) + y(i);
end;
