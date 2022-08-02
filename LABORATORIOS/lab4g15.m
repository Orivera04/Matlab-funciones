clc;
fprintf('BIENVENIDO AL JUEGO "ADIVINA EL NUMERO"\n');
entrar=input('\nDesea entrar al juego? \nSI=1 \nNO=2\n :')
if (entrar==2);
    clc;
    fprintf('SE HA SALIDO DEL JUEGO');
    break
elseif (entrar==1);
    clc;
else
    clc;
    fprintf('\t\tSOLO SE ACEPTAN LOS VALORES ESTABLECIDOS');
    break
    clc;
end
fprintf('JUGADOR 1. INTRODUZCA UN NUMERO PARA ADIVINAR');
numad=input('\nDe el numero: ');
clc;
fprintf('\t\tJUGADOR 2. ADIVINE EL NUMERO\n');
numbajo=0;
numalto=0;
intentos=0;

while 1
               
                  jugador2=input('\nDe un  numero: ');      
              if (jugador2<numad)
                  fprintf('\t\n¡¡FALLASTE!!');
                  fprintf('\n BAJO\n');
                  numbajo=numbajo+1;
              elseif (jugador2numad)
                  fprintf('\t\n¡¡FALLASTE!!');
                  fprintf('\ ALTO\n');
                  numalto=numalto+1;
              else
                  clc;
                  fprintf('\n¡¡ACERTASTES!!\n');
            fprintf('\nLa cantidad de numero bajo fue\n :'); 
            fprintf(' %d\n ',numbajo);
            fprintf('\nLa cantidad de numero alto fue\n :');
            fprintf(' %d\n',numalto);
            intentos=numbajo+numalto;
            fprintf('\nEl total de intentos es\n :');
            fprintf(' %d\n',intentos);
   break;
    end
    end