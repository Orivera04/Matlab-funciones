%Haga un programa en MatLab que calcule el volumen de una pirámide de base 
%rectangular sabiendo que:

%Volumen de la Pirámide = Área de la Base de la Pirámide (base) * Altura de la Pirámide (h)
%Area de la Base de la Pirámide = lado1 * lado 2

%Tanto los valores de los lados de la Base como el valor de la altura de la 
%Pirámide deben ser introducidos por el usuario. El programa debe imprimir el 
%resultado del cálculo del volumen.

clc;
lado1=input('Introduzca el valor del primer lado de la base de la piramide: ');
lado2=input('Introduzca el valor del segundo lado de la base de la piramide: ');
altura=input('Introduzca el valor de la altura de la piramide: ');
area= lado1*lado2;
vol=area*altura;
fprintf('Area de la base= %f unidades cuadradas\n',area);
fprintf('Volumen de la piramide= %f unidades cubicas',vol);