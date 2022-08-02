function b = comb3(r)
%Programa para construir combinaciones n_arias

%Formar matriz de combinaciones
a=sort(combina_2(r))
n=numel(r);
m=1;
p=2;
for i=1:n-1
        p=p+1
        for k=p:n
            b(m)=a(i)*r(k); 
            m=m+1;
        end

end

 b            
                