% LAB 4 Ejercicio 1
total=0;
mas='S'
while 1
    clc;
    importe=1;
    desc=0;
    i=1;
    compra=0;
    nombre=input('¿Cual es el nombre del cliente?: >>','s');
    while importe~=0
        fprintf('Cual es el valor del producto No %d: >> ',i);
        importe=input('');
        if importe~=0
            compra=compra+importe;
        end
        i=i+1;
    end
    fprintf('-------------------------\n');   
    fprintf('NOMBRE:           %s\n',nombre);
    fprintf('COMPRA:           C$ %.2f\n',compra);
    if (compra>=5000)&(compra<=12000)
        desc=compra * 0.15;
        compra=compra - desc;
    elseif compra > 12000
        desc=compra * 0.2;
        compra=compra - desc;
    end
    fprintf('DESCUENTO:        C$ %.2f\n',desc);
    fprintf('-------------------------\n');
    fprintf('TOTAL CLIENTE     C$ %.2f\n',compra);
    total=total+compra;
    mas=input('¿Mas clientes? S/N >> ','s');
    if (mas=='N')|(mas=='n')
        break;
    end
end
fprintf('\nEL TOTAL DE LAS VENTAS FUE DE C$ %.2f\n',total);