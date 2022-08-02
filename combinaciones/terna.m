function b=terna(r)
%Combinaciones ternarias de n elementos
n=numel(r);
a=sort(combina_2(r));
m=1;
p=3
for i=1:10
        for k=p:n
            
            b(m,k)=a(i)*r(k); 
           
        end
        m=m+1;
        p=p+1
end
