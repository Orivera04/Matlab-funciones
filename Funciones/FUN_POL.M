%FUNCIONES POLINOMICAS
clc
fprintf('Evaluación de polinomios:\n\n');
fprintf('Evaluar el siguiente polinomio en el intervalo [0,5]:\n\n');
fprintf('f(x) = -x^5 + 3x^3 - 2.5x^2 - 2.5\n\n');
fprintf('La instrucción MATLAB es la siguiente:\n\n');
fprintf('x=0.5:5/200:5;\n');
fprintf('a=[-1,0,3,-2.5,0,-2.5];\n');
fprintf('g=polyval(a,x);\n');
fprintf('plot(x,g),title(Función Polinómica);\n\n');
fprintf('Presione una tecla para ver la gráfica\n\n');
pause
x=0.5:5/200:5;
a=[-1,0,3,-2.5,0,-2.5];
g=polyval(a,x);
plot(x,g),title('Función Polinómica'),xlabel('Presione una tecla para cerrar la gráfica');
pause;
close
%****************************************************************************************
clc
fprintf('Suma de polinomios:\n\n');
fprintf('Supongamos que deseamos efectuar la siguiente suma de polinomios\n\n');
fprintf('g(x) = x^4 - 3x^2 - x + 2.4\n');
fprintf('h(x) = 4x^3 - 2x^2 + 5x - 16\n');
fprintf('s(x) = g(x) + h(x)\n\n');
fprintf('La instrucción MATLAB es la siguiente:\n');
fprintf('g=[1,0,-3,-1,2.4];\n');
fprintf('h=[0,4,-2,5,-16];\n');
fprintf('s=g+h;\n\n');
g=[1,0,-3,-1,2.4];
h=[0,4,-2,5,-16];
s=g+h;
fprintf('El resultado sería:\n\n');
fprintf('s = [ ');
fprintf('%.2f, ',s);
fprintf(']\n\n');
fprintf('Presione una tecla para continuar\n\n');
pause
%****************************************************************************************
clc
fprintf('Funciones conv y deconv\n\n');
fprintf('Considerar el siguiente producto de polinomios\n\n');
fprintf('g(x) = (3x^3 - 5x^2 + 6x - 2)(x^5 + 3x^4 - x^2 + 2.5)\n\n');
fprintf('La instrucción MATLAB es la siguiente:\n');
fprintf('a=[3,-5,6,-2];\n');
fprintf('b=[1,3,0,-1,0,2.5];\n');
fprintf('g=conv(a,b);\n\n');
a=[3,-5,6,-2];
b=[1,3,0,-1,0,2.5];
g=conv(a,b);
fprintf('El resultado sería:\n\n');
fprintf('g = [ ');
fprintf('%.1f, ',g);
fprintf(']\n\n');
fprintf('Presione una tecla para continuar\n\n');
pause
%****************************************************************************************
clc
fprintf('Considerar la siguiente división de polinomios\n\n');
fprintf('        3x^8 + 4x^7 - 9x^6 + 13x^5 - x^4 + 1.5x^3 - 10.5x^2 + 15x - 5\n');
fprintf(' h(x)= ---------------------------------------------------------------\n');
fprintf('                         x^5 + 3x^4 - x^2 + 2.5\n\n');
fprintf('La instrucción MATLAB es la siguiente:\n');
fprintf('g=[3,4,-9,13,-1,1.5,-10.5,15,-5];\n');
fprintf('b=[1,3,0,-1,0,2.5];\n');
fprintf('[q,r]=deconv(g,b);\n\n');
g=[3,4,-9,13,-1,1.5,-10.5,15,-5];
b=[1,3,0,-1,0,2.5];
[q,r]=deconv(g,b);
fprintf('El resultado sería:\n\n');
fprintf('q = [ ');
fprintf('%.1f, ',g);
fprintf(']\n\n');
fprintf('r = [ ');
fprintf('%.1f, ',r);
fprintf(']\n\n');
fprintf('Presione una tecla para terminar\n\n');
pause
clc
