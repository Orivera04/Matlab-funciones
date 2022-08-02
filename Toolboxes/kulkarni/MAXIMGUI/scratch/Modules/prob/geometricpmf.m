function y = geometricpmf(p,k)

% computes y(i) = P(X = i) for i=1,...k, where X ~ Geometric(p) $rv. Range 0 \le p \le 1.

y = zeros(1, k);
if k==0
   return
end

y(1) =  p;
for i=2:1:k
  y(i) = y(i-1)*(1-p);
end;
