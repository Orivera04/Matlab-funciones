%Ejemplo del uso de condicional IF
%Pedir al usuario un numero que este entre 1 y 5
%Si el numero es 1 el progrma imprime primero, si es 2 segundo, si es 3
%tercero, si es 4 cuarto y si es 5 quinto.

clc
n=input('Escriba un numero entre 1 y 5');
if n==1
    fprintf('primero');
end
if n==2
    fprintf('Segundo');
end
if n==3
    fprintf('Tercero');
end
if n==4
    fprintf('Cuarto');
end
if n==5
    fprintf('Quinto');
end
