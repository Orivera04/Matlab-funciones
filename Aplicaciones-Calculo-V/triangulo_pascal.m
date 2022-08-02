% a = triangulo_pascal(n)
function a = triangulo_pascal(n)
a=eye(n);     % Inicia a com identidade
              %(diagonal composta por 1's)
a(:,1)=1;     % Inicia primeira coluna com 1's
for i=3:n     % Compoe os demais elementos
    for j=2:i-1
        a(i,j)=a(i-1,j-1)+a(i-1,j);
    end
end
