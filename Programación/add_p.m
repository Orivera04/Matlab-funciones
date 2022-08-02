clc; %limpia la ventana de Matlab
ini=input('Introduzca el valor inicial: ');
fin=input('Introduzca el valor final:  ');
[s]=add(ini,fin);
fprintf('La suma de los valores desde %d hasta %d es: %d',ini,fin,s);