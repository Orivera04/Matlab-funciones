% Práctica 2.4a: Producto de una matriz triangular superior por un vector.
disp('Producto de una matriz triangular superior por un vector.');
n=input('¿Cuál es el tamaño de la matriz? ');
A=zeros(n);
c=zeros(n,1);
for i=1:n
   s=sprintf('Dame la fila %dª de A (sólo los elementos a la derecha del diagonal) ',i);
   A(i,i:n)=input(s);
end
v=input('Dame el vector v (como fila) ');
v=v';
A,v
for i=1:n
      c(i)=A(i,i:n)*v(i:n);
end
disp('El producto de A por v es')
disp(' ')
disp(c)
