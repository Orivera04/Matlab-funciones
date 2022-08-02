function L=cotasneg(p)
%Calcula las cotas inferiores de las raíces negativas de un polinomio.

n=numel(p);
%Obtener el polinomio p(-x)
for i=1:n-1
    q(i)=(-1)^n*(-1)^i*p(i);
end
q(n)=(-1)^n*p(n);
q;
%Calcular cotas de q
U=cotas(q);
L=-U;
end