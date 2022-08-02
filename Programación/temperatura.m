% Calcular la temperatura media (o promedio)
% y graficar los datos de temperatura.
%
tiempo = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0,...
3.5, 4.0, 4.5, 5.01];
temps = [105, 126, 119, 129, 132, 128, 131,...
135, 136, 132, 1371];
promedio = mean(temps)
plot(tiempo,temps);
title('~ediciones de temperatura');
xlabel('Tiempo, minutos'), ...
ylabel('Temperatura, grados F'),grid