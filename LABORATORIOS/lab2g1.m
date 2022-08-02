%Pausas para descompresion(Laboratorio #2)
% Jose Miguel Herrera Suarez
clc;
S=1;
while(S==1)
profundidad=input('Elija  una profundidad de inmersion ya sea 70, 80 o 90\n');
tiempo=input('Elija un tiempo ya sea 100, 110, 120 o 130\n');
if (profundidad==70)
    if(tiempo==100)
        a=0; b=33;
    elseif (tiempo==110)
        a=2; b=41;
    elseif (tiempo==120)
        a=4; b=47;
    elseif (tiempo==130)
        a=6; b=52;
    else
     fprintf('El tiempo esta fuera de rango\n');
 end;
elseif(profundidad==80)
    if (tiempo==100)
        a=11; b=46;
    elseif (tiempo==110)
        a=13; b=53;
    elseif (tiempo==120)
        a=17; b=57;
    elseif (tiempo==130)
        a=19; b=63;
    else 
        fprintf('El tiempo esta fuera de rango\n');
    end;
elseif(profundidad==90)
    if (tiempo==100)
        a=21; b=54;
    elseif(tiempo==110)
        a=24; b=61;
    elseif(tiempo==120)
        a=32; b=68;
    elseif(tiempo==130)
        a=36; b=74;
    else 
        fprintf('El tiempo esta fuera de rango\n');
    end;
else
    fprintf('Profundidad fuera de rango\n');
end;
pause;
fprintf('Para una inmersion de %d pies durante %d minutos se requieren las\n',profundidad,tiempo);
fprintf(' siguientes pausas de descompresion:\n');
fprintf('%d minutos en 20 pies\n',a);
fprintf('%d minutos en 10 pies\n',b);
fprintf('ADVERTENCIA:\n');
fprintf('"NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS"\n');
pause;
fprintf('¿Desea regresar al principio?\n');
fprintf('Si es si digite 1, si es no digite 2\n');
S=input('Diga si desea continuar\n');
end;
fprintf('Realizado por:\n');
fprintf('JOSE MIGUEL HERRERA SUAREZ Y OSMELL DARELL GUTIERREZ\n');
fprintf('GRACIAS PASE UN BUEN DIA\n');
end;