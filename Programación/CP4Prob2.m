%CP 4, Problema 2
clc
mayor=0;
for i=1:10
    fprintf('De el nombre del alumno #%d: >>',i);
    nombre=input('','s');
    fprintf('De la nota del alumno #%d: >>',i);
    nota=input('');
    if nota > mayor
        mayor=nota;
        nommayor=nombre;
    end
end
fprintf('\nEl nombre del alumno con la mayor nota es: %s\n',nommayor);
fprintf('La nota que corresponde a este alumno es: %d',mayor);