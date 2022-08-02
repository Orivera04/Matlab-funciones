function linea = grafica_recta(A,B,C)
%Este programa grafica una recta dados los coeficientes de su ec. general.

%Cálculo de intersecciones con los ejes
syms x y
ecua=A*x + B*y + C;
if C==0 
    x0=0;
    y0=0;
    y1=input('De un valor de y diferente de 0: ')
    x1=-B*y1/A
else
x0= 0;
y0=-C/B;
y1=0;
x1=-C/A;
end


%Gráfica de la recta
line([x0,x1],[y0,y1]);
