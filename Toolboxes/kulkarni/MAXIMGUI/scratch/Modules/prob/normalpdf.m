function y = normalpdf(m,s,x)

% computes y(i) = f(x(i)), where f is an normal(m,s)
% pdf. m is the mean and s is the variance. x is a row vector.

display_msg = 0 ;

si = size(x);
c = 1/sqrt(2*3.14159265358979*s);

for i=1:1:si(2)
  if abs(x(i)-m) > 10*sqrt(s)
    display_msg = 1 ;
  end;
  y(i) = c*exp(-.5*((m-x(i))^2/s));
end;

if display_msg == 1
  msgbox('x components too large or too small. Results may not be accurate');
end