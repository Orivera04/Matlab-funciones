%Raices
clc
fprintf('\n<<<< Raices de un polinomio >>>>\n');
fprintf('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n\n\n');
fprintf(' Considere la siguiente ecuación:\n');
fprintf('      x^2 + x - 6\n\n');
fprintf(' Las raices del polinomio serian:\n');
fprintf('     (x-2)(x-3)\n\n');
fprintf('Presione una tecla para ver la grafica...\n\n');
pause
x=-4:0.2:3;
ce=zeros(size(x));
a=[1,1,-6];
r=roots(a);
b=polyval(a,x);
d=zeros(size(r));
plot(x,b,'b',x,ce,'r',r,d,'y*'),title('Polinomio Cuadrático'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
fprintf('\n<<<< Posibilidades para las raices de un poloinomio cubico >>>>\n');
fprintf('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n\n\n');
fprintf(' >> a.)  3 raices reales distintas\n\n');
fprintf('      f1(x) = (x-3)(x+1)(x-1)\n');
fprintf('            = x^3 - 3x^2 -x + 3\n\n');
fprintf(' >> b.)  1 raiz real con multiplicidad de 3\n\n');
fprintf('      f2(x) = (x-2)^3\n');
fprintf('            = x^3 - 6x^2 +12x - 8\n\n');
fprintf(' >> c.)  1 raiz real simple y 1 raiz real con multiplicidad de 2\n\n');
fprintf('      f3(x) = (x+4)(x-2)^2\n');
fprintf('            = x^3 - 12x + 16\n\n');
fprintf(' >> d.)  1 raiz real y un par conjugado complejo de raices\n\n');
fprintf('      f4(x) = (x+2)(x-(2+i))(x-(2-i))\n');
fprintf('            = x^3 - 2x^2 -3x + 10\n\n');
fprintf('Presione una tecla para ver las graficas...\n\n');
pause
x=-5:0.2:5;
a1=[1,-3,-1,3];
a2=[1,-6,12,-8];
a3=[1,0,-12,16];
a4=[1,-2,-3,10];
b1=polyval(a1,x);
b2=polyval(a2,x);
b3=polyval(a3,x);
b4=polyval(a4,x);
subplot(2,2,1),plot(x,b1),title('Raices reales distintas'),grid;
subplot(2,2,2),plot(x,b2),title('Raices reales triples'),grid;
subplot(2,2,3),plot(x,b3),title('Raiz sencilla, raiz doble'),grid;
subplot(2,2,4),plot(x,b4),title('Raiz sencilla, raices complejas'),grid;
pause;
close
clc
fprintf('\n<<<< Funcion para extraer raices de un polinomio >>>>\n');
fprintf('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n\n\n');
fprintf(' Considere el siguiente polinomio:\n');
fprintf('     f(x) = x^3 - 2x^2 - 3x + 10\n\n');
fprintf(' Los comandos MATLAB para extraer las raices de este polinomio serian:\n\n');
fprintf('     p=[1,-2,-3,10];\n');
fprintf('     r=roots(p);\n\n');
p=[1,-2,-3,10];
r=roots(p);
fprintf(' El resultado seria:\n\n');
fprintf('   %.0f      ',r);
fprintf('\n\nPresione una tecla para continuar...\n\n');
pause
clc
fprintf('\n<<<< Funcion para determinar los coeficientes de un polinomio a partir de raices >>>>\n');
fprintf('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n\n\n');
fprintf(' Ej: calcular los coeficientes del polinomio cuyas raices son:-1,1 y 3\n\n');
fprintf(' El comando MATLAB para esto seria:\n\n');
fprintf('    a=poly[-1,1,3];\n\n');
a=poly([-1,1,3]);
fprintf(' El resultado seria:\n\n');
fprintf('    [ ');
fprintf('%.0f ',a);
fprintf(']\n\n');
fprintf('Presione una tecla para terminar...\n\n');
pause
clc