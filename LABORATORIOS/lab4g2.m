clc;
fprintf(' \t COMPAÑIA DE ELECTRICTDAD X\n');
i=0;
j=0;
while 1
fprintf(' Escoja el tipo de cliente\n 0 Particular\n 1 Empresa\n');
opcion= input(' Escojer tipo de cliente\n'); 
costo=0;
if opcion==0 | opcion==1
    consumo=input(' De el consumo en kwh\n');
    switch opcion
        case 0
           if(consumo>=0)&(consumo<=20)
                costo=consumo*10;
           elseif(consumo>=21)&(consumo<=50)
                costo=consumo*15;
           elseif(consumo>=51)&(consumo<=100)
                costo=consumo*25;
           else
                costo=consumo*30;
           end;
           fprintf('El costo del recibo es %.2f\n',costo);
        case 1
           if(consumo>=0)&(consumo<=20)
               costo=consumo*10;
           elseif(consumo>=21)&(consumo<=50)
               costo=consumo*20;
           elseif(consumo>=51)&(consumo<=100)
               costo=consumo*30;
           else
               costo=consumo*50;  
           end;
    end;
 else
     break;
end;
    if costo>1000
        j=j+1;
    end;
    i=i+1;
end;
fprintf(' El numero de recibos que han superado los 1000 es %d:\n',j);
fprintf(' El numero total de recibos es %d:\n',i);
end;