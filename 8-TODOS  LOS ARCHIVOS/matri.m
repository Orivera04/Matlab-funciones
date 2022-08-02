clc
disp('Programa que resuelve sistemas de ecuaciones por el metodo de cramer')
nume=input('Digite la cantidad de variables: ');
M=input('Digite la matriz M (debe tener la misma cantidad de filas y columnas ejemplo 5X5): ');
b=input('Digite el vector b: ');
m=det(M);
for (i=1:nume)
    A1=M;
    A1(:,i)=b';
    a1=det(A1);
    R(i)=a1/m;
end
fprintf('Las soluciones del sistema son: ');
R