% Pr�ctica 2.4b: Producto de dos matrices triangulares superiores.
disp('Producto de dos matrices triangulares superiores.');
n=input('�Cu�l es el tama�o de las matrices? ');
A=zeros(n);
B=A;
for i=1:n
   s=sprintf('Dame la fila %d� de A (s�lo los elementos a la derecha del diagonal) ',i);
   A(i,i:n)=input(s);
end
for i=1:n
   s=sprintf('Dame la fila %d� de B (s�lo los elementos a la derecha del diagonal) ',i);
   B(i,i:n)=input(s);
end
A,B
for i=1:n
   for j=i:n
      C(i,j)=A(i,i:j)*B(i:j,j);
   end
end
disp('El producto de A por B es')
disp(' ')
disp(C)
