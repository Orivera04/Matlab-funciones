function stars(t) 
%STARS(T) dibuja estrellas con parámetro t 
t=input('de el valor de t  ');
n = t * 50; 
plot(rand(1,n), rand(1,n),'.'); 
%esa línea dibuja n puntos aleatorios. 
title('Oh Dios, Está Lleno de Estrellas!'); 
%etiqueta la gráfica 
