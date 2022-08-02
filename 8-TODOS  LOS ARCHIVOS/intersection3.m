function h=intersection3()
syms A B C A1 B1 C1 
A=input('Digite el valor del coeficiente A  de la primer Ecuacion :')
B=input('Digite el valor del coeficiente B de la primer Ecuacion :')
C=input('Digite el valor del coeficiente C de la primer Ecuacion :')
A1=input('Digite el valor del coeficiente A1  de la segunda Ecuacion :')
B1=input('Digite el valor del coeficiente B1 de la segunda Ecuacion :')
C1=input('Digite el valor del coeficiente C1 de la segunda Ecuacion :')
x=[-3 -2 -1 0 1 2 3];
y=[-3 -2 -1 0 1 2 3];
[X,Y]=meshgrid(x,y)
Z=(A*X-B*Y)/C;
disp(Z)
mesh(Z)
grid on
hold on
x=[-3 -2 -1 0 1 2 3];
y=[-3 -2 -1 0 1 2 3];
[U,V]=meshgrid(x,y)
K=(A1*U-B1*V)/C1;
disp(K)
mesh(K)
hold on
n=numel(Z)
m=numel(K)
p=1;
for i=1:n
for j=1:m     
if Z(i) == K(j)
h(p)=Z(i);
p = p+1;
end
end
end
