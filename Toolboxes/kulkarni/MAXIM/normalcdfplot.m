function  normalcdfplot(m,s,x)
%normalcdfplot(m,s,x)
% computes y(i) = F(x(i)), where 
% F is an normal(m,s) cdf. m is the mean and s is the variance.
y=normalcdf(m,s,x);
if y(1) ~= 'error'
plot(x,y)
end;