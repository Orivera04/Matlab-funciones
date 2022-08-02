% Exercicios Propostos 04
function a = exercicios_propostos_04 (n)
for i=0:n-1
    nf=factorial(i);
    for j=0:i
        a(i+1,j+1)=nf/(factorial(j)*factorial(i-j));
    end
end

