clc;
monto=input('De el valor del monto inicial: ');
ai=input('De el valor del a�o inicial: ');
af=input('de el valor del a�o final: ');
[year,cap]=interes(monto,ai,af);
fprintf('El capital acumulado en %d a�os es de C$ %f',year,cap);
