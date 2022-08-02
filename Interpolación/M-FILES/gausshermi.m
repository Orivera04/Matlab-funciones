function I=gausshermi(f,a,b,n)

%I=gausshermi(f,a,b,n)
%Aproximates integral using Gauss-Hermite method
%Create function 'f' y=f(x);

%Hermite polynomial
p=hermipol(n);
%Roots
x=roots(p(n+1,:));

   G=feval(f,x);		%Function evaluation on the nodes

%Coeficients
for i=1:n
   C(i)=(2.^(n-1)*(factorial(n)).*sqrt(pi))./(n.^2.*(polyval(p(n,1:n),x(i))).^2);
end


I=dot(C,G);


