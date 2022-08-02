%LAB 4 Ejercicio 2
recibos=0;
superiores=0;
while 1
    clc
    fprintf('Los tipos de cliente para generar factura son:\n');
    fprintf('        * * * * * * * * * * * * *\n');
    fprintf('        *                       *\n');
    fprintf('        *   0  ->  Particular   *\n');
    fprintf('        *                       *\n');
    fprintf('        *   1  ->  Empresa      *\n');
    fprintf('        *                       *\n');
    fprintf('        * * * * * * * * * * * * *\n');
    fprintf('Digite un valor negativo para salir del programa\n\n');
    tipo=input('Digite su opcion: >> ');
    if tipo<0
        break;
    end
    consumo=input('De el valor del consumo en Kw(KiloWatts): >> ');
    switch tipo
        case 0
            if (consumo>=0)&(consumo<=20)
                coste=10*consumo;
            elseif (consumo>=21)&(consumo<=50)
                coste=15*consumo;
            elseif (consumo>=51)&(consumo<=100)
                coste=25*consumo;
            elseif (consumo>100)
                coste=30*consumo;
            end
        case 1
            if (consumo>=0)&(consumo<=20)
                coste=10*consumo;
            elseif (consumo>=21)&(consumo<=50)
                coste=20*consumo;
            elseif (consumo>=51)&(consumo<=100)
                coste=30*consumo;
            elseif (consumo>100)
                coste=50*consumo;
            end
    end
    fprintf('\n\nEl coste total del recibo es: C$%.2f',coste);
    recibos=recibos+1;
    if coste > 1000
        superiores=superiores + 1;
    end
    fprintf('\nPresione una tecla para continuar...');
    pause;
end
fprintf('\n\nEl numero total de recibos es: %d\n',recibos);
fprintf('El numero de recibos que supera los C$1000 es: %d',superiores);