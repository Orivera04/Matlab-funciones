function y = exppdf(l,x)
%y = exppdf(l,x)
% computes y(i) = f(x(i)), where f is an exp(l) pdf. x is a row vector.
if (l < 0) 
msgbox('invalid entry for l');y='error';return; 
else
si=size(x);
if si(1) > 1
msgbox('x must be a row vector.');y='error';return;
end;
y=zeros(1,si(2));
for i=1:1:si(2)
if x(i) < 0
y(i) = 0;
else
y(i)=l*exp(-l*x(i));
end;
end;
end;
