function v=trinf(A,b)
% Práctica 4.2b: Resuelve el sistema Av=b donde A es una matriz 
% triangular inferior.
n=size(A,1);
v(1)=b(1)/A(1,1);
for i=2:n
   v(i)=(b(i)-A(i,1:i-1)*v(1:i-1)')/A(i,i);
end
