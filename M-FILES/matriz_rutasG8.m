%Enlaces de vertices del grafo: N=8
%Matriz de enlaces:M. 
v1=[2,3]; 
v2=[3,4]; 
v3=[2,4,6]; 
v4=[5,6,7];
v5=[4,6,7];
v6=[4,5,7,8];
v7=[4,5,6,8];

for i=1:7
    MR(i,:)=input(['fila',num2str(i),': '])
end
MR         