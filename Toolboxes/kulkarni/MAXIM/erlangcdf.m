function y = erlangcdf(k,l,x)
%y = erlangcdf(k,l,x)
% computes y(i) = F(x(i)), where F is an erlang(k,l) cdf. x is a row vector.
if (k <= 0) | (k - fix(k) ~= 0)
msgbox('invalid entry for k');y='error';return; 
elseif (l < 0)
msgbox('invalid entry for l');y='error';return; 
else
si = size(x);
if si(1) > 1
   msgbox('x must be a row vector');y='error';return;
   end;
y=zeros(1,si(2));
for i=1:1:si(2)
if x(i) < 0
y(i) = 1;
elseif x(i) > k/l + 10*sqrt(k/l^2)
msgbox('x components too large. Results may not be accurate.')
else
y(i) = 1;
term = 1;
for r=1:k-1
term = term*l*x(i)/r;
y(i)=y(i) + term;
end;
y(i)=exp(-l*x(i))*y(i);
end;
end;
y=ones(1,si(2))-y;
end;
