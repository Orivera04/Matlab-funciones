function expcdfplot(l,x)
%expcdfplot(l,x)
% plots y(i) = F(x(i)), where F is an exp(l) cdf. x is a row vector.
y=expcdf(l,x);
if y(1) ~= 'error'
plot(x,y)
end;
