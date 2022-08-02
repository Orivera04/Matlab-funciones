clc;
fprintf('elaborado por: cristhian jose castellon\n  beverling amador \n');
fprintf ('         Desea jugar\n');
fprintf ('      Adivine el numero\n');
fprintf ('        1 (si)  2(no)\n');
jugar=input('                   ');
if (jugar==1)
numbajo=0;
numalto=0;
intentos=0;
jugador1=input ('de un numero:');
clc;
while 1
    jugador2=input('intente adivinar el numero\n ');
    if jugador1>jugador2
        fprintf('Demasiado bajo\n');
        numbajo=numbajo+1;
    elseif(jugador1<jugador2)
        fprintf ('demasiado alto\n');
        numalto=numalto+1;
    else
        fprintf('acertastes\n');
        intentos =numbajo+numalto;
        fprintf('hicistes %d intentos \n',intentos);
        fprintf ('hay %d numeros bajos \n ',numbajo);
        fprintf ('hay %d numeros altos \n',numalto);
        break;
    end
end
else (jugar==2)
    fprintf ('decidistes no   jugar\n')
end;
        
       