%Matriz de rutas para grafos no dirigidos

%1o. Introducir la matriz de enlaces M(i,j)=e
% i: No del vèrtice de patida
% j: No del enlace 1o., 2o. 3o.,etc
% e: No. del vértice de llegada.e=0 si no hay mas llegadas.
% Ej. M(1,2)=3. v. partida:1. No. de enlace:2. v. llegada:3
n=input('No de vertices del grafo: N=');
m=input('valencia máxima de los N vértices: ');
for i=1:n-1
    for j=1:m
      M(i,j)=input(['M(',num2str(i),',',num2str(j),')= ' ])
end
end
[n,m]=size(M);
A=[];
for i=1:m
    A=[A;1,M(1,i)];
end
[h,k]=find(A==0) %filas de A que contienen 0's.
A(h,:)=[] %borra las filas de A que contienen 0's.




