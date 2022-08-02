function y = expcdf(l,x)
%y = expcdf(l,x)
% computes and plots y(i) = F(x(i)), where F is an exp(l) cdf. x is a row vector.
if  (l <0)
msgbox('invalid entry for l');y='error';return; 
else
si=size(x);
if si(1) > 1
msgbox('x must be a row vector.');y='error';return;
end;
y = zeros(1,si(2));
for i=1:1:si(2)
if x(i) < 0
y(i) =0;
else
y(i)=1-exp(-l*x(i));
end;
end;
end;
