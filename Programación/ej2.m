%Ejemplo del uso de condicional Switch-Case
%Pedir al usuario un numero que este entre 1 y 5
%Si el numero es 1 el progrma imprime primero, si es 2 segundo, si es 3
%tercero, si es 4 cuarto y si es 5 quinto.

clc
n=input('Escriba un numero entre 1 y 5: ');
switch n
    case 1
        fprintf('Primero');
    case 2
        fprintf('Segundo');
    case 3
        fprintf('Tercero')
    case 4
        fprintf('Cuarto')
    case 5
        fprintf('Quinto')
    otherwise
        fprintf('El numero no esta entre 1 y 5');
end
