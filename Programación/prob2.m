%Haga un programa que permita imprimir el calculo correspondiente a la
%compra de un determinado articulo del que se adquieren una o varias
%unidades. El IVA a aplicar es el 15%, y si el precio total (importe + IVA)
%es mayor de 5000, se realiza un descuento del 5%.
clc;
precio=input('Cual es el precio de cada unidad del articulo: C$ ');
cantid=input('Cuantas unidades del articulo se van a comprar: # ');
importe = precio * cantid;
iva = (importe * 0.15);
preciototal = importe + iva;
fprintf('\nTOTAL:               C$ %.2f\n',importe);
fprintf('IVA:                 C$ %.2f\n',iva);
fprintf('                   ------------\n');
fprintf('TOTAL NETO:          C$ %.2f\n',preciototal);
fprintf('-------------------------------\n');
desc = 0;
if preciototal > 5000
    desc = preciototal * 0.05;
    preciototal = preciototal - desc;
end
fprintf('DESCUENTO:           C$ %.2f\n',desc);
fprintf('TOTAL A PAGAR:       C$ %.2f\n',preciototal);