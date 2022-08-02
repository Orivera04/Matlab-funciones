%PRUEBA 1, productos
sumtotal=0;
while 1
    clc
    compra=0;
    nombre=input('¿Cual es el nombre del cliente?: >> ','s');
    while 1
        precio=input('Precio del Producto: >> ');
        if precio==0
            break;    
        else
            compra=compra+precio;
        end
    end
    fprintf('Nombre del cliente:         %s\n',nombre);
    fprintf('Importe de la compra:       %d\n',compra);
    sumtotal=sumtotal+compra;
    seguir=input('¿Mas clientes? S/N: >> ','s');
    if (seguir=='n')|(seguir=='N')
        break;
    end
end
fprintf('\n\nEl importe total pagado por todos los clientes es:  %d',sumtotal);