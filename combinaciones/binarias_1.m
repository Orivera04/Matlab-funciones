%Programa para construir combinaciones binarias

%Introducir elementos a combinar
clear 
r=[1,2,3,4,5];
n=numel(r);

%Formar matriz de combinaciones
for i=1:n-1
    for j=1:n
        if i<j
            a(i,j)=r(i)*r(j);
        end
    end
end
a
b=a(a~=0)
d=diag(b)