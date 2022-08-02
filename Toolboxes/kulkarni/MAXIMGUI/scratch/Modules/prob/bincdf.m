function y = bincdf(n,p)

% computes y(i) = P(X \le i-1) for i=1,...n+1, where X ~ Binomial(n,p) rv.

y = zeros(1,n+1);
if p < .5
  pp = p/(1-p);
  term = (1-p)^(n/2);
  y(1) = term;
  for i=2:n+1
    term = term*(n-i+2)*pp/(i-1);
    y(i) = y(i-1) + term;
  end;
  y = (1-p)^(n/2) * y;
  y(n+1) = 1;

else
  pp = (1-p)/p;
  term = (p)^(n/2);y(1)=term;
  for i=2:n+1
    term = term*(n-i+2)*pp/(i-1);
    y(i) = y(i-1) + term;
  end;
  yy = (p)^(n/2) * y;
  for i=1:n
    y(i) = abs(1 - yy(n+1 -i));
  end;
  y(n+1) = 1;
end;
