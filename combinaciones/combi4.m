function b=combi4(r)
n=numel(r);
a=combina3(r);
m=1;
for i=1:n-1
    for j=i:n
        for k=j:n
            if j<k
            b(m,k)=a(i,j)*(r(k)+1); 
            end
        end
        m=m+1;
    end
end
