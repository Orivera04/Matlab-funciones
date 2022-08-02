% Calcular la temperatura media (o promedio)
% y graficar los datos de temperatura.Pag. 23.
tiempo = [0.0, 0.5, 1.01];
temps = [105, 126, 119];
promedio = mean(temps)
plot(tiempo,temps),title('Mediciones de temperatura'), ...
xlabel('Tiempo, minutos'), ...
ylabel('Temperatura, grados F'),grid