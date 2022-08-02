function y = normalpdf(m,s,x)
%y = normalpdf(m,s,x)
% computes y(i) = f(x(i)), where f is an normal(m,s)
% pdf. m is the mean and s is the variance. x is a row vector.
if (s < 0)
msgbox('invalid entry for s');y='error';return; 
else
si=size(x);
if si(1) > 1
msgbox('x must be a row vector.');y='error';return;
end;
c=1/sqrt(2*3.14159265358979*s);
for i=1:1:si(2)
if abs(x(i)-m) > 10*sqrt(s)
disp('x components too large or too small. Rsults may not be accurate');
end;
y(i)=c*exp(-.5*((m-x(i))^2/s));
end;
end;
