function b=combina_4(r)
%Combinaciones ternarias de n elementos
n=numel(r);
a=combina3(r);
m=1;
for i=1:n-1
    for j=i:n-1
        for k=4:n
            if j<k
            b(m,k)=a(i,j)*r(k);
            end
        end
        m=m+1;
    end
    %m=m+1;
end
%b=b(3:end,4:end)
b
