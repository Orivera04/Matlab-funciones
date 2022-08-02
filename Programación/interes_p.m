clc;
monto=input('De el valor del monto inicial: ');
ai=input('De el valor del año inicial: ');
af=input('de el valor del año final: ');
[year,cap]=interes(monto,ai,af);
fprintf('El capital acumulado en %d años es de C$ %f',year,cap);
