function exppdfplot(l,x)
%exppdfplot(l,x)
% plots y(i) = f(x(i)), where f is an exp(l) pdf. x is a row vector.
y=exppdf(l,x);
if y(1) ~= 'error'
plot(x,y)
end;
