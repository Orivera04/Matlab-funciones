function Y=diffinli(p,q,r,aa,bb,alfa,beta,n)

% Solves linear boundary problem using finite differences method
% Y=diffinli('p','q','r',aa,bb,alfa,beta,n)
% y''=p(x)*y'+q(x)*y+r(x);
% Edit p.m, q.m and r.m;
% aa = initial point "a";
% bb = final point "b";

h=(bb-aa)/(n+1);
x=aa+h;

a(1)=2+h.^2.*feval(q,x);
b(1)=-1+(h/2)*feval(p,x);
d(1)=-h.^2.*feval(r,x)+(1+(h/2)*feval(p,x)).*alfa;

for i=2:(n-1)
   x=aa+(i)*h;
   a(i)=2+h.^2.*feval(q,x);
   b(i)=-1+(h/2).*feval(p,x);
   c(i)=-1-(h/2).*feval(p,x);
   d(i)=-h.^2.*feval(r,x);
end

x=bb-h;
a(n)=2+h.^2.*feval(q,x);
c(n)=-1-(h/2).*feval(p,x);
d(n)=-h.^2.*feval(r,x)+(1-(h/2)*feval(p,x)).*beta;

%Resolution of the tridiagonal system
l(1)=a(1);
u(1)=b(1)./a(1);
for i=2:(n-1);
   l(i)=a(i)-c(i).*u(i-1);          
   u(i)=b(i)./l(i);
end
l(n)=a(n)-c(n).*u(n-1);             


z(1)=d(1)./l(1);
for i=2:(n);
   z(i)=(d(i)-c(i).*z(i-1))./l(i);
end


y(n+1)=beta;
y(n)=z(n);
for i=(n-1):-1:1
   y(i)=z(i)-u(i).*y(i+1);
end
y=[alfa y];
%End of resolution;

for i=0:(n+1)
   x(i+1)=aa+(i).*h;
end
Y(:,1)=x';
Y(:,2)=y';
