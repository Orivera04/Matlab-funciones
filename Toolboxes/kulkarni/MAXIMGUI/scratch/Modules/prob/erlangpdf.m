function y = erlangpdf(k,l,x)

% computes y(i) = f(x*(i-1)/20) for i=1,...20, where f is an erlang(k,l) pdf.

si = size(x);
y = zeros(1,si(2));

for i=1:1:si(2)
  if x(i) < 0
    y(i) = 0;
  else
    y(i) = l*exp(-l*x(i))*(l*x(i))^(k-1)/prod([1:k-1]);
  end;
end;
