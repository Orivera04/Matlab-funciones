function b=combina4(r)
%Combinaciones ternarias de n elementos
n=numel(r);
a=combina3(r);
m=1;
for i=1:n-1
    for j=i:n
        for k=1:n
            if j<k
            b(m,k)=a(i,j)*r(k);
            end
        end
        m=m+1;
    end
end
