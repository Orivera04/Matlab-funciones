% En la caja registradora de un establecimiento hay billetes de diferentes
% denominaciones en centavos, billetes de 1, 5, 10 y 25 centavos. Escriba un
% programa en Matlab que reciba del usuario la cantidad de billetes de cada
% denominacion y devuelva la suma total en cordobas de todos los billetes.

clc;
uno=input('¿Cuantos billetes de 1 centavo tiene?:  ');
cinco=input('¿Cuantos billetes de 5 centavos tiene?:  ');
diez=input('¿Cuantos billetes de 10 centavos tiene?:  ');
veinticinco=input('¿Cuantos billetes de 25 centavos tiene?:  ');
suma=(uno/100)+(cinco/20)+(diez/10)+(veinticinco/4);
fprintf('\nUd tiene %.2f cordobas en billetes de 1,5,10 y 25 centavos',suma);