%programa #4,Luz Keyling Aleman y Richard Bravo, grupo#7
clc;
intentos=0;
NAltos=0;
NBajos=0;
fprintf('Juguemos ¡Adivina un numero\n!');
fprintf('jugador 1 de tu numero\n');
numero=input('Numero');
clc;
while 1
    fprintf('Jugador 2: Adivina el numero\n');
    numero2=input('numero');
    if (numero2==numero)
        fprintf('acertaste\n');
        break
    else if (numero2>numero)
            fprintf('Demasiado alto,intenta de nuevo\n');
            NAltos=NAltos+1;
        else if (numero2<numero)
                fprintf('Demasiado bajo, intenta de nuevo\n');
                NBajos=NBajos+1;
            end
        end
    end
end
intentos=NAltos+NBajos;
fprintf('el numero de intentos realizados es igual a:%d\n',intentos);
fprintf('la cantidad de numeos altos introducidos es igual a:%d\n',NAltos);
fprintf('la cantidad de numeos bajos introducidos es igual a:%d\n',NBajos);