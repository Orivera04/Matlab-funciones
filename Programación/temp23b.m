% Calcular la temperatura media (o promedio)
% y graficar los datos de temperatura. Pag. 23.
tiempo = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0 ,3.5, 4.0, 4.5, 5.01];
temps = [105, 126, 119, 129, 132, 128, 131 ,135, 136, 132, 137];
promedio = mean(temps)
plot(tiempo,temps),title('mediciones de temperatura'),...
xlabel('Tiempo, minutos'), ...
ylabel('Temperatura, grados F'),grid