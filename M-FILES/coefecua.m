%Coeficientes de ecuaciones ec=A1*exp1+A2*exp2+...+An*exp(n)
%Definición de la expresión ejemplo
syms x y w z
exp(1)=2*x;
exp(2)=-5*y;
exp(3)=8*w;
exp(4)=-7*z;
vecexp=[exp(1),exp(2),exp(3),exp(4)]
exp=exp(1)+exp(2)+exp(3)+exp(4)
exp1=subs(vecexp,[x,y,w,z],[x,x^2,x^3,x^4])
exp2=exp1(1)+exp1(2)+exp1(3)+exp1(4)
poli=sym2poly(exp2)
poli1=fliplr(poli)
coef1=poli1(2)
coef2=poli1(3)
coef3=poli1(4)
coef4=poli1(5)