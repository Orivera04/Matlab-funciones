%PRACTICA DE RAICES DE POLINOMIO
clc
fprintf('Determine las raices reales de los siguientes polinomios.Luego grafique cada\n');
fprintf('polinomio en un intervalo apropiado a fin de verificar que cruza el eje x en\n');
fprintf('las posiciones de las raices reales.\n\n');
fprintf('1.)    g1(x) = x^3 - 5x^2 + 2x + 8\n');
fprintf('2.)    g2(x) = x^2 + 4x + 4\n');
fprintf('3.)    g3(x) = x^2 - 2x + 2\n');
fprintf('4.)    g4(x) = x^5 - 3x^4 - 11x^3 + 27x^2 + 10x - 24\n');
fprintf('5.)    g5(x) = x^5 - 4x^4 - 9x^3 + 32x^2 + 28x - 48\n');
fprintf('6.)    g6(x) = x^5 + 3x^4 - 4x^3 - 26x^2 - 40x - 24\n');
fprintf('7.)    g7(x) = x^5 - 9x^4 + 35x^3 - 65x^2 + 64x - 26\n');
fprintf('8.)    g8(x) = x^5 - 3x^4 + 4x^3 - 4x + 4\n\n');
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
g1=[1 -5 2 8];
g2=[1 4 4];
g3=[1 -2 2];
g4=[1 -3 -11 27 10 -24];
g5=[1 -4 -9 32 28 -48];
g6=[1 3 -4 -26 -40 -24];
g7=[1 -9 35 -65 64 -26];
g8=[1 -3 4 0 -4 4];
r1=roots(g1);
r2=roots(g2);
r3=roots(g3);
r4=roots(g4);
r5=roots(g5);
r6=roots(g6);
r7=roots(g7);
r8=roots(g8);
%1.)****************************************************************************************
fprintf('1.)    g1(x) = x^3 - 5x^2 + 2x + 8\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r1);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=-1.1:0.1:4.1;
b=polyval(g1,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
%2.)****************************************************************************************
fprintf('2.)    g2(x) = x^2 + 4x + 4\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r2);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause;
x=-3:0.1:-1;
b=polyval(g2,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
%3.)****************************************************************************************
fprintf('3.)    g3(x) = x^2 - 2x + 2\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r3);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=0:0.1:2;
b=polyval(g3,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
%4.)****************************************************************************************
fprintf('4.)    g4(x) = x^5 - 3x^4 - 11x^3 + 27x^2 + 10x - 24\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r4);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=-3:0.1:4;
b=polyval(g4,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para ver intervalos mas cortos'),grid;
pause;
close;
x=-4:0.1:0;
ce=zeros(size(x));
b=polyval(g4,x);
subplot(2,1,1),plot(x,b,'b',x,ce,'r'),grid;
x=0:0.1:5;
ce=zeros(size(x));
b=polyval(g4,x);
subplot(2,1,2),plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la grafica'),grid;
pause
close
clc
%5.)****************************************************************************************
fprintf('5.)    g5(x) = x^5 - 4x^4 - 9x^3 + 32x^2 + 28x - 48\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r5);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=0:0.1:5;
b=polyval(g5,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
%6.)****************************************************************************************
fprintf('6.)    g6(x) = x^5 + 3x^4 - 4x^3 - 26x^2 - 40x - 24\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r6);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=-3:0.1:4;
b=polyval(g6,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para ver intervalos mas cortos'),grid;
pause;
close
x=-3:0.1:0;
ce=zeros(size(x));
b=polyval(g6,x);
subplot(2,1,1),plot(x,b,'b',x,ce,'r'),grid;
x=0:0.1:4;
ce=zeros(size(x));
b=polyval(g6,x);
subplot(2,1,2),plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la grafica'),grid;
pause
close
clc
%7.)****************************************************************************************
fprintf('7.)    g7(x) = x^5 - 9x^4 + 35x^3 - 65x^2 + 64x - 26\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r7);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=0:0.1:2;
b=polyval(g7,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
%8.)****************************************************************************************
fprintf('8.)    g8(x) = x^5 - 3x^4 + 4x^3 - 4x + 4\n\n');
fprintf('Las raices del polinomio son:\n');
disp(r8);
fprintf('\n\n');
fprintf('Presione una tecla para ver la gráfica...\n\n');
pause
x=-1.5:0.1:0;
b=polyval(g8,x);
ce=zeros(size(x));
plot(x,b,'b',x,ce,'r'),xlabel('Presione una tecla para cerrar la gráfica'),grid;
pause;
close
clc
