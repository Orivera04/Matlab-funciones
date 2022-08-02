%PRACTICA DE FUNCIONES POLINOMICAS
clc
fprintf('Suponga que se han dado los siguientes polinomios:\n\n');
fprintf('f1(x)= x^3 - 3x^2 - x + 3\n');
fprintf('f2(x)= x^3 - 6x^2 + 12x - 8\n');
fprintf('f3(x)= x^3 - 8x^2 + 20x - 16\n');
fprintf('f4(x)= x^3 - 5x^2 + 7x - 3\n');
fprintf('f5(x)= x - 2\n\n');
fprintf('Grafique cada una de las siguientes funciones en el intervalo[0,4].\n');
fprintf('Use funciones MATLAB con vectores de coeficientes de polinomios para\n');
fprintf('evaluar las expresiones.\n\n');
fprintf('1.    f1(x)                                  2.     f2(x) - 2 f4(x)\n');
fprintf('3.    3 f5(x) + f2(x) - 2 f3(x)              4.     f1(x) * f3(x)\n');
fprintf('5.    f4(x) / (x-1)                          6.     f1(x) * f2(x) / f5(x)\n\n');
%******************************************************************************************
x=[0:0.20:4];
a1=[1,-3,-1,3];
a2=[1,-6,12,-8];
a3=[1,-8,20,-16];
a4=[1,-5,7,-3];
a5=[0,0,1,-2];
a6=[1,-2];

%1.****************************************************************************************
clc
fprintf('1.    f1(x)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
b=polyval(a1,x);
plot(x,b),title('Grafica de f1(x)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%2.****************************************************************************************
clc
fprintf('2.    f2(x) - 2 f4(x)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
c=2*a4;
d=a2-c;
b=polyval(d,x);
plot(x,b),title('Grafica de f2(x) - 2 f4(x)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%3.****************************************************************************************
clc
fprintf('3.    3 f5(x) + f2(x) - 2 f3(x)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
c=3*a5;
d=2*a3;
f=c+a2;
g=f-d;
b=polyval(g,x);
plot(x,b),title('Grafica de 3 f5(x) + f2(x) - 2 f3(x)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%4.****************************************************************************************
clc
fprintf('4.    f1(x) * f3(x)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
c=conv(a1,a3);
b=polyval(c,x);
plot(x,b),title('Grafica de f1(x) * f3(x)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%5.****************************************************************************************
clc
fprintf('5.    f4(x) / (x-1)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
c=x-1;
[q,r]=deconv(a4,c);
b=polyval(q,x);
plot(x,b),title('Grafica de f4(x) / (x-1)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%6.****************************************************************************************
clc
fprintf('6.    f1(x) * f2(x) / f5(x)\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
c=conv(a1,a2);
[q,r]=deconv(c,a6);
b=polyval(q,x);
plot(x,b),title('Grafica de f1(x) * f2(x) / f5(x)'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
