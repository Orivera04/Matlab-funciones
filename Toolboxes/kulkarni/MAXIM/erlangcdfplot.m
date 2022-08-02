function erlangcdfplot(k,l,x)
%erlangcdfplot(k,l,x)
% plots y(i) = F(x(i)), where F is an erlang(k,l) cdf. x is a row vector.

y=erlangcdf(k,l,x);
if y(1) ~= 'error'
plot(x,y)
end;