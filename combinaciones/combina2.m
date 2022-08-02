function a=combina2(r)
%Programa para construir combinaciones binarias 
n=numel(r);
for i=1:n-1
    for j=1:n
        if i<j
            a(i,j)=r(i)*r(j);
        end
    end
end
