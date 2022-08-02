%Programa para construir combinaciones binarias

%Introducir elementos a combinar
r=['a','b','c','d','e'];
n=numel(r);

%Formar matriz de combinaciones
com='';
for i=1:n-1
    for j=2:n
        if i<j
            el=strcat(r(i),r(j));
            com=strvcat(com,el);
        end
    end
end
com

