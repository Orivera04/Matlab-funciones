% Supongamos que la prima por seguro de salud se descuenta de un empleado
% de acuerdo al siguiente plan:
%          1 -> 9.75  Si es soltero
% Prima    2 -> 16.25 Si es casado y sin hijos
%          3 -> 24.5  Si es casado y con hijos
%Hacer un programa que pida el monto del pago y calcule el neto deduciendo la prima
%de seguro de acuerdo al tipo de prima.
clc
pago=input('Introduzca el monto del salario: ');
fprintf('Escriba:\n');
fprintf('1 - Si es soltero\n');
fprintf('2 - Si es casado y sin hijos\n');
fprintf('3 - Si es casado y con hijos\n');
prima=input('Seleccion: ');
if prima==1
    neto=pago-9.75;
    fprintf('\nEl pago Neto es: %f\n\n',neto);
elseif prima==2
    neto=pago-16.25;
    fprintf('\nEl pago Neto es: %f\n\n',neto);
elseif prima==3
    neto=pago-24.5;
    fprintf('\nEl pago Neto es: %f\n\n',neto);
else
    fprintf('El numero no corresponde a ningun tipo de prima');
end