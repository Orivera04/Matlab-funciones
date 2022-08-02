%Programa para obtener el polinomio simétrico (-1)^n*p(-x)
%cuyas raices son las negativas de las de p(x).

%Introducir el polinomio p
p=input('Dar coeficientes de p ');
n=numel(p);

%Obtener el polinomio p(-x)
for i=1:n-1
    q(i)=(-1)^n*(-1)^i*p(i);
end
q(n)=(-1)^n*p(n);
q
    