function y = geometriccdf(p,k)

% computes y(i) = P(X <= i) for i=1,...k, where X ~ Geometric(p) $rv. 

for i=1:1:k
  y(i) = 1-(1-p)^i;
end;
