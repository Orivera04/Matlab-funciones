%PRUEBA 1, Bono
totalbonos=0;
while 1
    clc
    sumsal=0;
    nombre=input('¿Cual es el nombre del empleado?: >> ','s');
    for i=1:3
        fprintf('De el salario del mes # %d:',i);
        salario=input(' >> ');
        sumsal=sumsal+salario;
    end
    bono=sumsal*0.1;
    fprintf('Nombre del empleado:     %s\n',nombre);
    fprintf('Monto del Bono:          %d\n',bono);
    totalbonos=totalbonos+bono;
    seguir=input('¿Mas empleados? S/N: >> ','s');
    if (seguir=='n')|(seguir=='N')
        break;
    end
end
fprintf('\n\nEl monto total pagado por la empresa es: %d',totalbonos);