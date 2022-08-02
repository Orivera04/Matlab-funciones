%Se lee un vector que contiene tiempos y temperaturas
% y se grafica el vector temperaturas contra el vector tiempo
timetemp=[1 2 3 4 5 6 7 8 9 10; 30 25 34 40 31 24 18 24 27 15]

% Los tiempos están e la 1a fila y las temperaturas en la segunda.
time = timetemp(1,:);
temp = timetemp(2,:);

% Se dibuja la gráfica y se ponen etiquetas y título.
plot(time,temp,'-r*')
xlabel('Tiempo')
ylabel('Temperatura')
title('Temperaturas por la tarde')
