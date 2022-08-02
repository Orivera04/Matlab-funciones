%Programa para dibujar puntos  puntos y calcular distancias.
%Introduzca los puntos como vectores
x=input('Deme las coordenadas del punto x: ');
y=input('Deme las coordenadas del punto y: ');
%Cálculo de la distancia entre los dos puntos
dist=norm(y-x);
disp('La distancia entre los puntos x e y es: ');
dist
%Dibujar los puntos x,y
axis([x(1)-1 y(1)+1 x(2)-1 y(2)+1])
hold on
DrawPoint(x);
DrawPoint(y);
plot([x(1) y(1)],[x(2) y(2)]);
hold off