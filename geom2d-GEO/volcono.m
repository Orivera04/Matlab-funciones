%Programa para encontrar el volumen de un cono
clc
disp('Introduzca el valor del radio');
r = input('radio = ');
disp('Introduzca el valor de la altura');
h = input('altura = ');
Volumen = (1*pi*(r^2)*h)/3;
disp('El volumen de un cono es: '); disp(Volumen)
