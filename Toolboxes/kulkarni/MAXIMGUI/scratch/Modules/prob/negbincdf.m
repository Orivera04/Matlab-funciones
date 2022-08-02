function y = negbincdf(r,p,k)

% computes y(i) = P(X \le i) for i=r, r+1,..., r+k,
% where X ~ Negative Binomial (r,p) $ rv.  

y = negbinpmf(r,p,k);
for i=2:r+k
  y(i) = y(i)+y(i-1);
end;
