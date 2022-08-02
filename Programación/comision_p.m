clc;
monto=input('Introduzca el monto de las ventas: ');
[comis]=comision(monto);
fprintf('La comision del empleado sobre las ventas es de: C$ %.2f',comis);