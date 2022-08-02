%Ejemplo del uso de condicional Switch-Case
%Pedir al usuario un numero que este entre 1 y 5
%Si el numero es 1 el progrma imprime primero, si es 2 segundo, si es 3
%tercero, si es 4 cuarto y si es 5 quinto.

clc
n=input('Escriba un numero entre 1 y 5 : ');
switch n
    case 1
        fprintf('Primero\n');
    case 2
        fprintf('Segundo\n');
    case 3
        fprintf('Tercero\n')
    case 4
        fprintf('Cuarto\n')
    case 5
        fprintf('Quinto\n')
    otherwise
        fprintf('El numero no esta entre 1 y 5\n');
end
