function y = negbinpmf(r,p,k)

% computes y(i) = P(X = i) for i=r, r+1,..., r+k, where X ~ Negative Binomial (r,p) $ rv. 

y = zeros(1,r+k);
y(r) = p^r;
for i=r+1:r+k
  y(i) = y(i-1)*(i-1)*(1-p)/(i-r);
end;
