%Dibujo de un punto  
%Se crean las coordenadas del punto
x = 11;
y = 48;
%Se dibuja el punto como un asterisco rojo
plot(x,y,'r*')
% Se cambia el rango de los ejes y se etiquetan
axis([9 12 35 55])
xlabel('Tiempo')
ylabel('Temperatura')
% Se pone un título a la gráfica.
title('Tiempo y Temperatura')
