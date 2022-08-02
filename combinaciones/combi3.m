%Programa para construir combinaciones ternarias

%Introducir elementos a combinar
clear;
r=[1,2,3,4,5];
n=numel(r);

%Formar matriz de combinaciones
for i=1:n-1
    for j=2:n
        if i<j
            a(i,j)=r(i)*r(j);
        end
    end
end
a;
m=1;
for i=1:n-1
    for j=2:n
        p=a(i,j);
        for k=3:n
            if j<k
            b(m)=p*r(k);  
            m=m+1;
            end
        end
    end
end
 comb=b(b~=0)             
 %comb=reshape(b,6,4)
                