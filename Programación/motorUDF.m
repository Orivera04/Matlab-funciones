%Estos comandos generan y grafican valores de velocidad
%y aceleracion en un intervalo especificado por el usuario.
%
tiempo_inicial = input('Teclee el tiempo inicial (en segundos) : ');
tiempo_final = input( ' Teclee el tiempo final (max. 120 segundos) : ');
%
incremento_tiempo = (tiempo_final - tiempo_inicial)/99;
tiempo = tiempo_inicial:incremento_tiempo:tiempo_final;
velocidad = 0.00001*tiempo.^3-0.00488*tiempo.^2+0.75795*tiempo+181.3566;
aceleracion = 3 - 0.000062*velocidad.^2;
%
subplot(2,1,1), plot(tiempo,velocidad),title('velocidad'),ylabel('mts/seg'),grid,...
subplot(2,1,2), plot(tiempo,aceleracion),title('aceleracion'),xlabel('tiempo, seg'),...
ylabel('mts/seg^2'),grid

