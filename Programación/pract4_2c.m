function v=trsup(A,b)
% Práctica 4.2c: Resuelve el sistema Av=b donde A es una matriz 
% triangular superior.
n=size(A,1);
v(n)=b(n)/A(n,n);
for i=n-1:-1:1
   v(i)=(b(i)-A(i,i+1:n)*v(i+1:n)')/A(i,i);
end
