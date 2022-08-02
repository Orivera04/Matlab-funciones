%PRUEBA 1, Alumnos
clc
contalum=0;
sumnotaclase=0;
promclase=0;
while 1
    clc;
    nombre=input('¿Cual es el nombre del alumno?: >> ','s');
    sumnota=0;
    contnota=0;
    while 1
        nota=input('De la nota >> ');
        if nota >=0
            contnota=contnota+1;
            sumnota=sumnota+nota;
        else
            break;
        end
    end
    promalum=sumnota/contnota;
    fprintf('Nombre del alumno:    %s\n',nombre);
    fprintf('Promedio de notas:    %d\n\n',promalum);
    contalum=contalum+1;
    sumnotaclase=sumnotaclase+promalum;
    seguir=input('¿Mas alumnos? S/N: >> ','s');
    if (seguir=='n')|(seguir=='N')
        break;
    end
end
promclase=sumnotaclase/contalum;
fprintf('\n\nEl promedio de la clase es: %d',promclase);