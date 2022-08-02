function y = expcdf(l,x)

% computes y(i) = F(x(i)), where F is an exp(l) cdf and x is a row vector.

si = size(x);
y = zeros(1,si(2));
for i=1:1:si(2)
  if x(i) < 0
    y(i) =0;
  else
    y(i) = 1-exp(-l*x(i));
  end;
end;
