% Practica de la Pagina 142
n=0;
while n ~= 7,
  clc
  n=menu('Seleccione una funcion','sin x','cos x','tan x','cot x','sec x','csc x','SALIR');
  if n==1
     a=input('Dar ángulo a evaluar  x= ');
     fprintf('\nsin x =     %f',sin(a));
  elseif n==2
   a=input('Dar ángulo a evaluar  x= ');
     fprintf('\ncos x =     %f',cos(a));
     elseif n==3
   a=input('Dar ángulo a evaluar  x= ');
     fprintf('\ntan x =     %f',tan(a));
     elseif n==4
   a=input('Dar ángulo a evaluar  x= ');
     fprintf('\ncot x =     %f',cot(a));
     elseif n==5
   a=input('Dar ángulo a evaluar  x= ');
     fprintf('\nsec x =     %f',sec(a));
     elseif n==6
   a=input('Dar ángulo a evaluar  x= ');
     fprintf('\ncsc x =     %f',csc(a));
  end
  if n ~= 7
    fprintf('\n\nPresione una tecla para volver al menú...\n');
    pause
    clc
 end
end