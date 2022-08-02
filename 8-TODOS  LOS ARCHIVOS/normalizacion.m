function ecnormal=normalizacion(A,B,C)
%Normalización de la ecuación de una recta con ec. general.
%Ax+By+C=0
if C>0
    a=-A; b=-B; c=-C;
else 
    a=A; b=B; c=C;
end
den=sqrt(a^2+b^2);
An=a/den;
Bn=b/den;
Cn=c/den;
syms x y
%ec_normal=horzcat(ecnor,'=0')
ecnor=char('An*x+Bn*y+Cn');
ecnormal=eval(ecnor);


