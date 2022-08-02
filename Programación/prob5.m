%Supongase que el importe del seguro obligatorio de un coche depende del
%modelo del automovil, del color del automovil y de la edad del conductor.
%Sean dos modelos de coche A y B y los precios del seguro segun el color:
%
%   MODELO      COLOR           PRECIO ($)
%                
%                 Blanco          240.41
%       A         Metalizado      330.00
%                 Otros           270.50
%  -----------------------------------------               
%                 Blanco          300.00
%       B         Metalizado      360.50
%                 Otros           330.00
% 
%Si el conductor tiene menos de 26 años, el precio se incrementa un 5%, si
%tiene entre 26 y 30 años se incrementa un 10%, si tiene entre 31 y 65 años
%el precio no se modifica, si tiene mas de 65 años el precio se incrementa
%un 10%. Haga un programa que calcule el precio del seguro para un
%determinado modelo y un determinado conductor.

clc
modelo = input('Cual es el modelo (A o B): > ','s');
modexist='V';
colexist='V';
switch modelo
    case {'A','a'}
        color = input('Cual es el color del automovil(Blanco,Metalizado u Otros): > ','s');
        color = upper(color);
        switch color
            case 'BLANCO'
                precio = 240.41;
            case 'METALIZADO'
                precio = 330;
            case 'OTROS'
                precio = 270.5;
            otherwise
                colexist='F';
        end
    case {'B','b'}
        color = input('Cual es el color del automovil(Blanco,Metalizado u Otros): > ','s');
        color = lower(color);
        switch color
            case 'blanco'
                precio = 300;
            case 'metalizado'
                precio = 360.5;
            case 'otros'
                precio = 330;
            otherwise
                colexist='F';
        end
    otherwise
        modexist='F';
end
if modexist == 'F'
    fprintf('\nEl modelo de automovil que introdujo no existe\n');
else
    if colexist == 'F'
        fprintf('\nEl modelo de automovil que introdujo no existe\n');
    else
        edad = input('Cual es la edad del conductor: > ');
        if edad < 26
            precio = precio + (precio * 0.05);
        elseif ((edad >= 26) & (edad <= 30)) | (edad > 65)
            precio = precio + (precio * 0.1);
        end
        fprintf('\nMODELO DEL AUTOMOVIL:    %s\n',upper(modelo));
        fprintf('COLOR DEL AUTOMOVIL:     %s\n',upper(color));
        fprintf('EDAD  DEL CONDUCTOR:     %d\n',edad);
        fprintf('-------------------------------\n');
        fprintf('PRECIO  DEL  SEGURO:     $%.2f',precio);
    end
end