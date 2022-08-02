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
a
m=1;

for i=1:n-1
    for j=2:n
        for k=3:n
            if m>12
                break
            end
               if k>j 
                  b(m,k)=a(i,j)*r(k);  
                  m=m+1;
              end
            end
        end
end
b(13,5)=60;
b
comb=b(b~=0) 
b=b(:,3:5)

 
