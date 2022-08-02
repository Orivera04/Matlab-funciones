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

switch i
    case 1
    for j=1:n
        for k=1:n
            if j<k
            b(j,k)=a(i,j)*r(k); 
           
            end
        end
    end
  case 2
    disp('No hay resultados')
    
  end
    b