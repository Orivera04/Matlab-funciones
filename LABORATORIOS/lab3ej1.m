%LAB 3 EJERCICIO 1. VENTA DE BIILLETES DE AUTOBUS
clc;
plazas=input('¿Cuantas plazas hay disponibles en el autobus? > ');
opc=0;%inicializar las opciones a 0 para que no sea ninguna del menu
libres=plazas;%Al principio las plazas libres son las plazas totales del autobus
while opc~=4 %mientras la opcion elegida no sea salir
    clc;
    fprintf('MENU DE OPCIONES:\n\n');
    fprintf('               * * * * * * * * * * * * * * * *\n');
    fprintf('               *                             *\n');
    fprintf('               *   1. VENTA DE BILLETES      *\n');
    fprintf('               *                             *\n');
    fprintf('               *   2. DEVOLUCION DE BILLETES *\n');
    fprintf('               *                             *\n');
    fprintf('               *   3. ESTADO DE LA VENTA     *\n');
    fprintf('               *                             *\n');
    fprintf('               *   4. SALIR                  *\n');
    fprintf('               *                             *\n');
    fprintf('               * * * * * * * * * * * * * * * *\n\n');
    opc=input('Que opcion desea ejecutar: > ');% pedir la opcion
    clc;
    switch opc% evaluar la opcion
        case 1 %En caso de que sea VENTA DE BILLETES
            while 1
                venta=input('¿Cuantos billetes desea comprar? > '); %pedir los billetes a comprar
                if venta > libres %si se piden mas billetes de los libres
                    fprintf('\nNo se le pueden vender %d billetes\n',venta);
                    fprintf('Solo hay %d billetes disponibles\n\n',libres);
                    decision=input('¿Desea aun comprar billetes? S/N > ','s');
                    if decision=='S'|decision=='s'
                        clc;
                    elseif decision=='N'|decision=='n'
                        break;
                    end
                else %si no se piden mas billetes de los que se puedan vender
                    libres=libres-venta;
                    break; 
                end
            end
        case 2 % En caso de que la opcion sea DEVOLUCION DE BILLETES
            while 1
                devol=input('¿Cuantos billetes desea devolver? > ');
                if devol>(plazas-libres)
                    fprintf('\nNo es posible que vaya a devolver esa cantidad de billetes.\n');
                    fprintf('El autobus tiene %d plazas y se han vendido %d.\n\n',plazas,plazas-libres);
                    decision=input('¿Desea aun devolver billetes? S/N > ','s');
                    if decision=='S'|decision=='s'
                        clc;
                    elseif decision=='N'|decision=='n'
                        break;
                    end
                else
                    libres=libres+devol;
                    break;
                end
            end
        case 3
            fprintf('PLAZAS TOTALES DEL AUTOBUS:        %d\n\n',plazas);
            fprintf('PLAZAS LIBRES DEL AUTOBUS:         %d\n',libres);
            fprintf('PLAZAS VENDIDAS DEL AUTOBUS:       %d\n\n',plazas-libres);
            fprintf('Presione una tecla para volver al menu...');
            pause;
        case 4
            fprintf('Las plazas estan completamente vendidas y el programa ha finalizado.\n\n');
            fprintf('Presione una tecla para continuar...');
            pause; clc;
            break;
        otherwise
            fprintf('El numero de la opcion no esta contemplado en el menu.');
    end
    if libres==0
        fprintf('Las plazas estan completamente vendidas y el programa ha finalizado.\n\n');
        fprintf('Presione una tecla para continuar...');
        pause; clc;
        break;
    end
end