function suma

% Esta funcion calcula la sumatoria de una serie infinita 
% convergente. Es necesario introducir como parametro de entrada 
% el n-esimo termino de la serie infinita convergente en 
% terminos de la variable n y el valor inicial de dicha variable.

clc;
clear all;
syms serie n;

serie=input('\nIntroduzca el n-esimo termino de la serie infinita en terminos de la variable n\n y luego presione enter:\n\n');
n_inicial=input('\n Introduzca el valor inicial de la variable n\n');

funcion_suma(serie,n_inicial)

%titulo=sprintf('\n La suma es:\n%s',resultado);
%disp(titulo)

function sumatoria=funcion_suma(serie,n_inicial)

sumatoria=symsum(serie, n_inicial,inf);

