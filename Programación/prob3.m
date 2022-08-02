% Haga un programa que pida 2 numeros nota y edad y un caracter 'sexo' y
% muestre el mensaje 'ACEPTADA' si la nota es mayor o igual a cinco, la
% edad es mayor o igual a dieciocho y el sexo es 'M'. En caso de que se
% cumpla lo mismo, pero el sexo sea 'V', imprimir 'POSIBLE'.
clc
nota = input('Cual es la nota: ');
edad = input('Cual es la edad: ');
sexo = input('Cual es el sexo (M o V): ','s');
if (nota >= 5) & (edad >= 18)
    if (sexo == 'M') | (sexo == 'm')
        fprintf('\nACEPTADA\n');
    elseif (sexo == 'V') | (sexo == 'v')
        fprintf('\nPOSIBLE\n');
    end
else
    fprintf('\nINDETERMINADO\n');
end