function y = binpmf(n,p)
% y = binpmf(n,p)
% computes y(i) = P(X = i-1) for i=1,...n+1, where X ~ Binomial(n,p) rv.
yy = bincdf(n,p);
if yy(1) ~= 'error'
y(1) = yy(1);
for i = 2:n+1;
y(i) = yy(i) - yy(i-1);
end;
end;
