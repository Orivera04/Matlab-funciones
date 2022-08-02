function y = normalcdf(m,s,x)

% computes y(i) = F(x(i)) where F is an normal(m,s) cdf. m is the mean and s is the variance. 
% x is a row vector.

display_msg = 0 ;

c = 1/sqrt(2*3.14159265358979);
si = size(x);

for i=1:1:si(2)
  xi = (x(i)-m)/sqrt(s) ;
  if xi > 6*sqrt(s)
    display_msg = 1 ;
  end;

  y(i) = 0; 
  term = xi;
  k = 0;

  while (abs(term) > 10^(-10))
    y(i) = y(i) + term/(2*k+1);
    k = k+1;
    term = -term*xi^2/(k*2);
  end;
  y(i) = .5+c*y(i);
end;

if display_msg == 1
  msgbox('x components too large. Results may not be accurate.');
end
