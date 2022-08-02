%pausas para descompresion
%Sadik Ali Campos Sanchez
%Marlon Antonio Amador Herrera

clc;
fprintf('Este programa te ofrece un menu de inmersion en pies:\n');
fprintf('1 profundidad a 70 pies\n');
fprintf('2 profundidad a 80 pies\n');
fprintf('3 profundidad a 90 pies\n');
profundidad=input('Elija una de las opciones anteriores');
fprintf('Esta opcion posee una variacion de tiempo en el fondo\n');
fprintf('1 En 100 minutos\n');
fprintf('2 En 110 minutos\n');
fprintf('3 En 120 minutos\n');
fprintf('4 En 130 minutos\n');
tiempo=input('Determine un tiempo para la inmersion=');
switch profundidad
    case 1
        a=70;
        switch tiempo
            case 1
                b=100; c=0; d=33;
            case 2
                b=110; c=2; d=41;
            case 3
                b=120; c=4; d=47;
            case 4
                b=130; c=6; d=52;
        end;
    case 2
        a=80;
        switch tiempo
            case 1
                b=100; c=11; d=46;
            case 2
                b=110; c=13; d=53;
            case 3
                b=120; c=17; d=56;
            case 4
                b=130; c=19; d=63;
        end;
    case 3
        a=90;
        switch tiempo
            case 1
                b=100; c=17; d=54;
            case 2
                b=110; c=24; d=61;
            case 3
                b=120; c=32; d=68;
            case 4
                b=130; c=36; d=74;
        end;
end;
pause;clc;
fprintf('Para una inmersion a %d pies durante %d minutos se requieren las siguientes pausas de descompresion:\n',a,b);
fprintf('%d minutos a 20 pies\n',c);
fprintf('%d minutos a 10 pies\n',d);
fprintf('ADVERTENCIA: "No se sumerga sin los conocimientos apropiados"\n');
end;
pause;clc;
fprintf('Desea salir\n');
fprintf('Desea continuar\n');
a=input('De el numero')
b=input('De el numero')
if (a==1);
    clc;
   fprintf('Hecho por SADIK ALI CAMPOS SANCHEZ Y MARLON ANTONIO AMADOR HERRERA');
end;
if (b==2);
 run lab2
end;
