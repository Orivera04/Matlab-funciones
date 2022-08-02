function b=combina_4(r)
%Combinaciones ternarias de n elementos
n=numel(r);
a=combina3(r);
m=1;
for i=1:n-1
    for j=i+1:n
        for k=j+1:n
            b(m,k)=a(i,j)*r(k);
        end
        m=m+1;
    end
    %m=m+1;
end
b

