function erlangpdfplot(k,l,x)
% plots y(i) = f(x(i)), where f is an erlang(k,l) pdf. x is a row vector.
y=erlangpdf(k,l,x);
if y(1) ~= 'error'
plot(x,y)
end;
