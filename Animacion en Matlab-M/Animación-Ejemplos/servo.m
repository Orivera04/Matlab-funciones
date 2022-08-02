%SIMULACIÓN DE UN SERVOSISTEMA PARA UN PÉNDULO INVERTIDO
%MONTADO SOBRE UNA BASE MÓVIL

%Borra la consola, todas las variables y cierra todas las ventanas graficas
clc,clear all,close all

%Definición de la planta sin el integrador externo:
A=[0 1 0 0; 0 0 -0.49 0; 0 0 0 1; 0 0 10.29 0]; 
B=[0 0.2 0 -0.2]'; C=[1 0 0 0];
%Definición de la planta con el integrador externo:
AA=[0 -1 0 0 0; 0 0 1 0 0; 0 0 0 -0.49 0; 0 0 0 0 1;
0 0 0 10.29 0 ]; BB=[0 0 0.2 0 -0.2]'; CC=[0 1 0 0 0];
rangoMMc=rank(ctrb(AA, BB))
if rangoMMc < 5 %¿El sistema es controlable?
   fprintf('El sistema no es controlable\n')
else
   fprintf('El sistema es controlable \n')
	KK=acker(AA, BB, [-0.8+1.3141j -0.8-1.3141j -4 -4 -4])
    AAA=AA-BB*KK; BBB=[2 0 0 0 0]'; %Ec. en lazo cerrado
    sistema=ss(AAA, BBB, CC, 0);
   [y,t,x]=step(sistema, 0:0.01:7);
   plot(t,x)
   %Animacion
   disp('Pulse una tecla para continuar...');
   pause
   figure,carro(x(:,4),x(:,2),1,-KK*x',[],5);%Ajustar el ultimo nº para que la animacion se vea bien
   disp('Fin de la animacion')
end


