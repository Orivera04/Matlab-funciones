%LAB 4 Ejercicio 4
numalum=0;
sumalum=0;
while 1
    clc
    nombre=input('De el nombre del estudiante: >> ','s');
    numnota=0;
    i=1;
    nota=0;
    sumnota=0;
    while nota>=0
        fprintf('De la nota No %d: >> ',i);
        nota=input('');
        if nota>=0
            numnota=numnota+1;
            sumnota=sumnota+nota;
            prom=sumnota/numnota;
        end
        i=i+1;
    end
    fprintf('NOMBRE:      %s\n',nombre);
    fprintf('PROMEDIO:    %.2f\n\n',prom);
    numalum=numalum+1;
    sumalum=sumalum+prom;
    mas=input('¿Mas Alumnos? S/N >> ','s');
    if (mas=='N')|(mas=='n')
        break;
    end
end
fprintf('\n\nLa nota promedio de la clase es: %.2f',sumalum/numalum);