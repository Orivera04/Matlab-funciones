%Xochilt Lourdes Alvarez
%Marlen J Miranda Centeno

clc;     
fprintf('el programa nos presenta: las pausas para descompresion');
profundidad=input('de los valores de profundidad');
switch profundidad
case 70
   tiempo=input('de el tiempo');
   switch tiempo
case 100
    fprintf('a 20 pies, el tiempo en minuto es de 0 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 33 minutos de profundidsd \n');
case 110
    fprintf('a 20 pies, el tiempo en minuto es de 2 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 41 minutos de profundidsd \n');
case 120
    fprintf('a 20 pies, el tiempo en minuto es de 4 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 47 minutos de profundidsd \n');
case 130
    fprintf('a 20 pies, el tiempo en minuto es de 6 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 52 minutos de profundidsd \n');
otherwise
    fprintf('este valor no se encuentra en el rango\n');
end;
case 80
    tiempo=input('de el tiempo');
    switch tiempo
        case 100
           fprintf('a 20 pies, el tiempo en minuto es de 11 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 46 minutos de profundidsd \n');
    case 110
    fprintf('a 20 pies, el tiempo en minuto es de 13 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 53 minutos de profundidsd \n');
case 120
    fprintf('a 20 pies, el tiempo en minuto es de 17 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 56 minutos de profundidsd\n');
case 130
  fprintf('a 20 pies, el tiempo en minuto es de 19 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 63 minutos de profundidsd \n');
otherwise
    fprintf('este valor no se encuentra en el rango\n');
end;
case 90
    tiempo=input('de el tiempo');
    switch tiempo
        case 100
           fprintf('a 20 pies, el tiempo en minuto es de 21 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 54 minutos de profundidsd \n');
    case 110
    fprintf('a 20 pies, el tiempo en minuto es de 24 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 61 minutos de profundidsd \n');
case 120
    fprintf('a 20 pies, el tiempo en minuto es de 32 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 68 minutos de profundidsd\n');
case 130
  fprintf('a 20 pies, el tiempo en minuto es de 36 minutos de profundidad\n');
    fprintf('a 10 pies,el tiempo en minuto es de 74 minutos de profundidsd \n');
otherwise
    fprintf('este valor no se encuentra en el rango\n');
end;
otherwise
    fprintf('este valor no se encuentra en la base de datos\n');
end;
end;
fprintf('ADVERTENCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS ASPROPIADOS\n');
