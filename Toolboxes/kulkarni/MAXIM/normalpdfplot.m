function normalpdfplot(m,s,x)
%normalpdfplot(m,s,x)
% computes y(i) = f(x(i)), where f is an normal(m,s)
% pdf. m is the mean and s is the variance. x is a row vector.

y=normalpdf(m,s,x);
if y(1) ~= 'error'
   plot(x,y)
   end;
