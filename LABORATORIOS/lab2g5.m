%Ammy Alfaro Caracas
%Elizabeth Almanza C

clc;
profundidad=input('de la profundidad de inmersion:70,80,90\n');
tiempo=input('de el tiempo:100,110,120,130\n');
if(profundidad==70)
    if(tiempo==100)
        a=0; b=33;
    elseif(tiempo==110)
        a=2, b=41;
    elseif(tiempo==120)
        a=4; b=47;
    elseif(tiempo==130)
        a=6; b=52;
    else
        disp('ERROR');
    end;
elseif(profundidad==80)
    if(tiempo==100)
        a=11; b=46;
    elseif(tiempo==110)
        a=13; b=53;
    elseif(tiempo==120)
        a=17; b=57;
    elseif(tiempo==130)
        a=19; b=63;
    else
        disp('ERROR');
    end;
elseif(profundidad==90)
    if(tiempo==100)
        a=21; b=54;
    elseif(tiempo==110)
        a=24; b=61;
    elseif(tiempo==120)
        a=32; b=68;
    elseif(tiempo==130)
        a=36; b=74;
    else
        disp('ERROR');
    end;
else
    disp('profundidad fuera de rango');
end;
fprintf('para una inmersion a %d pies durante %d minutos se requieren las siguientes pausas de descompresion:', profundidad,tiempo);
fprintf('%d minutos en 20 pies\n',a);
fprintf('%d minutos en 10 pies\n',b);
fprintf('ADVERTENCIA: "NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS".')
        