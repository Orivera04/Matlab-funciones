function b=combina_3(r)
%Combinaciones ternarias de n elementos
n=numel(r);
a=combina2(r);
m=1;
for i=1:n-2
    for j=i+1:n-1
        for k=j+1:n
            %if j<k
            b(m,k)=a(i,j)*(r(k)+1); 
            %end
        end
        m=m+1;
    end
end
