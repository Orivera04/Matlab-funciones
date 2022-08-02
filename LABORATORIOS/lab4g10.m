clc;
total=0;
suma=0;
while 1
fprintf ('Esta es una Compañia Electrica\n');
fprintf ('Hay dos Opciones de Clientes\n');
fprintf ('*******************************\n');
fprintf ('Digite el 0 si es un Particular\n');
fprintf ('Digite el 1 si es un Empresa\n');
x= input ('   ');
switch x
    case 0
        fprintf ('Ingresa tu Nombre:');
        a=input (' ','s');
        fprintf ('Tu Nombre es: %s\n',a);
        fprintf('Ingresa el Consumo en Kwh\n');
        y=input('');
        if y<=20;
            costo=y*10;
            fprintf ('_______________________________________________________\n');
            fprintf ('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('________________________________________________________\n');
        elseif ((y>=21)&(y<=50));
            costo=y*15;
            fprintf ('_______________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('_______________________________________________________\n');
        elseif ((y>=51)&(y<=100));
            costo=y*25;
            fprintf ('_______________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('_______________________________________________________\n');
        elseif y>100;
            costo=y*30;
            fprintf ('_______________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('________________________________________________________\n');
        end
        fprintf('\n\n\n');
        fprintf('Que Desea Realizar Ahora:\n');
        fprintf('1 Si Desea Salir\n');
        fprintf('2 Si Desea Volver al Programa\n');
        fprintf('3 Si Desea ver su Bibliografia\n');
        a=input('  ');
        if (a==1);
            break 
            fprintf('Esto fue Hecho en Matlab-Laboratorio de Computacion UNI\n\n');
        end
            fprintf ('\t..\t..\t..Realizado por Jose Antonio Flores y Rodney Muller Linarte 1M1-CO...\n\t\t\t\t\t\t\t\tUNIVERSIDAD NACIONAL DE INGENIERIA\n');
    case 1
        fprintf ('Ingresa el Nombre de la Empresa:\n');
        a=input (' ','s');
        fprintf ('Tu Nombre es: %s\n',a);
        fprintf('Ingresa el Consumo en Kwh\n');
        y=input('');
        if y<=20;
            costo=y*10;
            fprintf ('_______________________________________________________\n');
            fprintf ('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('______________________________________________________\n');
        elseif ((y>=21)&(y<=50));
            costo=y*15;
            fprintf('_______________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
             fprintf ('_____________________________________________________\n');
        elseif ((y>=51)&(y<=100));
            costo=y*25;
            fprintf('_______________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('______________________________________________________\n');
        elseif y>100;
            costo=y*30;
            fprintf('_______________________________________________________________\n');
            fprintf('Tu Pagaras por %d Kwh el Costo de: %d(Cordobas Netos)\n',y,costo);
            fprintf ('_____________________________________________________________\n');
        end
        fprintf('\n\n\n');
        fprintf('Que Desea Realizar Ahora:\n');
        fprintf('1 Si Desea Salir\n');
        fprintf('2 Si Desea Volver al Programa\n');
        fprintf('3 Si Desea ver su Bibliografia\n');
        a=input('  ');
        if (a==1);
            break 
            fprintf('Esto fue Hecho en Matlab-Laboratorio de Computacion UNI\n\n');
        end
            fprintf ('\t..\t..\t..Realizado por Jose Antonio Flores y Rodney Muller Linarte 1M1-CO...\n\t\t\t\t\t\t\t\tUNIVERSIDAD NACIONAL DE INGENIERIA\n');
    end
    if costo>=1000;
       suma=suma+1;
   end
   total=total+1
end
fprintf ('Los Recibos Totales fueron %d\n',total);
fprintf ('Los que Superan los Miles son %d\n',suma);
