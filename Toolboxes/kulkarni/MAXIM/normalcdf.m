function y = normalcdf(m,s,x)
%y = normalcdf(m,s,x)
% computes y(i) = F(x(i)) where F is an normal(m,s) cdf. m is the mean and s is the variance. x is a row vector.
if  (s < 0)
msgbox('invalid entry for s');y='error';return; 
else
c=1/sqrt(2*3.14159265358979);
si=size(x);
if si(1) > 1
msgbox('x must be a row vector.');y='error';return;
end;
for i=1:1:si(2)
xi=(x(i)-m)/sqrt(s) ;
if xi > 6*sqrt(s)
disp('x components too large. Results may not be accurate.');
end;

y(i)=0; term = xi;k=0;
while (abs(term) > 10^(-10))
y(i) = y(i) + term/(2*k+1);
k = k+1;
term = -term*xi^2/(k*2);
end;
y(i) = .5+c*y(i);
end;
end;
