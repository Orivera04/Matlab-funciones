function integrar_fc_racional 
clc;
clear all;
disp('Evaluacion de una integral indefinida cuyo integrando');
disp('lo constituye una expresion racioanal de la forma');
disp('f(x)/g(x) donde f(x) y g(x) son polinomios');
disp('------------------------------------------------------');
syms x;
numerador=input('\nIntroduzca el polinomio f(x) en terminos de la variable "x" y luego presione enter: \n\n');
denominador=input('\nIntroduzca el polinomio g(x) en terminos de la variable "x" y luego presione enter: \n\n');
resultado=int(numerador/denominador);
titulo=sprintf('\nEl resultado es: ');
disp(titulo);
pretty(resultado)