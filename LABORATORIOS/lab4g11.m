clc;
disp('                             Den sus nombre');
nombre=input('1er jugador                     ','s');
nom=input('2do jugador                        ','s');
fprintf('                    !hola! como estas %s\n',nombre);
fprintf('                    !hola! como estas %s\n',nom);
fprintf('                     De un numero %s\n',nombre)
jugador1=input('                       ');
clc;
disp('                          *ADIVINE EL NUMERO* ');
x=0;y=0;
jugar=0;
while jugar<=1;
    fprintf('                     Adivine el numero que ingreso %s\n',nombre);
    jugador2=input('                            ');
    if jugador2<jugador1
        disp('                           FALLO');        
        disp('                El numero es -DEMASIADO BAJO-');
        x=x+1;
    elseif jugador2>jugador1
        disp('                           FALLO');
        disp('                El numero es -DEMASIADO ALTO-');
        y=y+1;
    else 
        disp( '                     ****FELICIDADES****');
        disp('                         -ACERTASTES-');
        i=x+y;
        fprintf('                 Hicistes %d intentos por todos\n ',i);
        fprintf('          introdujistes %d numeros bajo y %d numeros altos\n ',x,y);
        fprintf ('   si quieres seguir jugando oprime 1, de lo contrario oprime el 2\n');
        disp('                      Oprima el numero:');
        jugar=input('                             ');
    end 
   if jugar==2
        break;
    end
end
disp('                         REALIZADO POR:');
disp('               Norman Altamirano y Sergio Gaitan' );
disp('       para cerrar el programa presione cualquier tecla');
pause;
exit;
        
