% Practica de la Pagina 142
n=0;
while n ~= 7,
  clc
  n=menu('Seleccione una funcion','coth x','sec','csc x','acoth','asech x','acsc x','SALIR');
  if n==1
     a=input('Cual es el angulo a evaluar  >>');
     fprintf('\ncoth x =     %f',atan(pi/2));
  end
  if n ~= 7
    fprintf('\n\nPresione una tecla para volver al menú...\n');
    pause
    clc
 end
end