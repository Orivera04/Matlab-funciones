function U=cotas(p)
%Programa para calcular cotas de las raíces reales de un polinomo
% con los metodos de Lagrange y de Brest.

%Introducir el polinomio p
%Calcular el grado de p
n=numel(p);
%Calcular el primer coeficiente negativo de p
%Método de Lagrange

in=find(p<0);
k=min(in)-1;
cn=p(in);
G=max(abs(cn));
U1=1+(G/p(1))^(1/k);

%Método de Brest;
%Calcular fracciones 

m=numel(in);
k=in(1)-1;
suma(1)=sum(p(1:k));
frac(1)=p(in(1))*(-1)/suma(1);
for j=1:m-1
    k1=in(j)+1;
    k2=in(j+1)-1;
    suma(j+1)=suma(j)+sum(p(k1:k2));
    frac(j+1)=p(in(j+1))*(-1)/suma(j+1);
end
frac;
U2=max(frac)+1;
U=min(U1,U2);
end