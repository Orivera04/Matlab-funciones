%Programa para determinar la divisibilidad de un polinomio p
%entre un binomio x-a, donde a es un divisor del término inde-
%pendiente pn de p=[p1,p2,...,pn+1]. p1=1,a debe ser entero.

clc;
%Dar coeficientes del polinomio p
p=input('vector de coeficientes de p: ');
%Hallar los divisores de p
n=numel(p);
indep=abs(p(n));
dpos=divisors(indep);
dneg=-dpos;
D=[dpos,dneg];
m=numel(D);

%Aplicar M. de Horner para determinar la divisibilidad de p entre x-a
k=1;
raices=[];
for i=1:m
    [coc,rest]=horner1(p,D(i));
    while rest==0
        raices(k)=D(i)
        disp('x-a(k) es un factor de p');
        p=coc;
        [coc,rest]=horner1(p,D(i));
        k=k+1;
    end
end
clc;
disp('El No. de raíces enteras es:');
n=k-1
 disp('Las raíces enteras son:');
 raices
        
    
    
    
