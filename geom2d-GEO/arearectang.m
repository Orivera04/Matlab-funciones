%Inicio
%   Imprimir "Introduzca el valor de la Base del rectangulo:"
%   Leer base
%   Imprimir "Introduzca el valor de la altura del rectangulo:"
%   Leer altura
%   Area=(base * altura)/2
%   Imprimir "El area del rectangulo es:" Area
%Fin
clc;
fprintf('Introduzca el valor de la Base del rectangulo: ');
base=input('');
fprintf('\nIntroduzca el valor de la Altura del rectangulo: ');
altura=input('');
Area=(base * altura)/2;
fprintf('\n\nEl area del rectangulo es: %d',Area);
