%SIMULACIÓN DE UN SISTEMA REGULADOR PARA UN PÉNDULO INVERTIDO
%MONTADO SOBRE UNA BASE MÓVIL

%Borra la consola, todas las variables y cierra todas las ventanas graficas
clc,clear all,close all

%definición de la planta:
A=[0 1 0 0; 0 0 -0.49 0; 0 0 0 1; 0 0 10.29 0];
B=[0 0.2 0 -0.2]'; C=[1 0 0 0; 0 0 1 0];
rangoMc=rank(ctrb(A, B))%¿El sistema es controlable?
if rangoMc < 4
   fprintf('El sistema no es controlable\n')
else
   fprintf('El sistema es controlable \n')
	%Cálculo del vector de ganancias para la ubicación de polos:
	K=acker(A, B, [-1.25+2.0532j -1.25-2.0532j -6.25 -6.25])
	AA=A-B*K; %Matriz de estado del sistema en lazo cerrado
	sistema=ss(AA, [0,0,0,0]', C, 0);
   %Se perturba al sistema con un ángulo inicial de 0.15 rad.
   [y,t,x]=initial(sistema, [0 0 -0.15 0]',[0:0.001:5]); plot(t,x)
   %Animacion
   disp('Pulse una tecla para continuar...');
   pause
   figure,carro(x(:,3),x(:,1),1,-K*x',[-1.5,1.5],30);%Ajustar el ultimo nº para que la animacion se vea bien
   disp('Fin de la animacion')
end