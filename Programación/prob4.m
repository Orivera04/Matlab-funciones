% Haga un programa que calcule, segun la siguiente tabla el impuesto a
% pagar segun el salario anual. Se pediran como datos al usuario el salario
% mensual y el numero de pagos.
%
%        SALARIO ANUAL                PORCENTAJE DE IMPUESTO
%    -----------------------          ----------------------
%     < 1000,000                             5%
%     1,000,000 - 2,500,000                  12%
%     2,500,001 - 3,800,000                  15%
%     3,800,001 - 6,000,000                  22%
%     > 6,000,000                            30%

clc;
salmen=input('Introduzca el valor del salario mensual: C$ ');
numpag=input('Introduzca el numero de meses a pagar:    # ');
salanual = salmen * 12;
if salanual < 1000000
    porc = 0.05;
elseif (salanual >= 1000000) & (salanual <= 2500000)
    porc = 0.12;
elseif (salanual >= 2500001) & (salanual <= 3800000)
    porc = 0.15;
elseif (salanual >= 3800001) & (salanual <= 6000000)
    porc = 0.22;
elseif (salanual > 6000000)
    porc = 0.30;
end
pago = (salmen * numpag);
impuesto = pago * porc;
total = pago - impuesto;
fprintf('\nSALARIO BRUTO:      C$%.2f\n',pago);
fprintf('IMPUESTO:           C$%.2f\n',impuesto);
fprintf('------------------------------\n');
fprintf('SALARIO NETO:       C$%.2f\n',total);