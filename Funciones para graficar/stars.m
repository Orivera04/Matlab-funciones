function stars(t) 
%STARS(T) dibuja estrellas con par�metro t 
t=input('de el valor de t  ');
n = t * 50; 
plot(rand(1,n), rand(1,n),'.'); 
%esa l�nea dibuja n puntos aleatorios. 
title('Oh Dios, Est� Lleno de Estrellas!'); 
%etiqueta la gr�fica 
