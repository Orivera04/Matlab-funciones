%LAB 4 Ejercicio 3
clc
num=input('Introduzca el numero a adivinar: >>');
clc
bajos=0;
altos=0;
intentos=0;
while 1
    numadiv=input('¿Cual es el numero? >>');
    if numadiv < num
        fprintf('Demasiado bajo\n\n');
        bajos=bajos+1;
    elseif numadiv > num
        fprintf('Demasiado alto\n\n');
        altos=altos+1;
    elseif numadiv==num
        fprintf('ACERTASTE\n\n');
        break;
    end
    intentos=intentos+1;
end
fprintf('TOTAL DE INTENTOS:     %d\n',intentos);
fprintf('NUMEROS ALTOS:         %d\n',altos);
fprintf('NUMEROS BAJOS:         %d\n',bajos);