%programa que permite realizar descuento en un comercio x%
%lab4g1 Osmell Darell Gutierrez Alvarez y Jose Miguel Herrera Suarez%
clc;
tipo_de_negocio=input('Diga que clase de negocio es\n  ', 's');
propetario=input('De el nombre del negocio \n  ', 's');
j=10;
suma_total=0;
while j==10
nombre_del_cliente=input('De el nombre del cliente\n  ','s');
importe=0;
subtotal=0;
total=0;
descuento=0;
i=1;
while i==1
    cantidad=input('De la cantidad de los productos adquiridos\n ');
    costo=input('De el costo de cada producto\n ');
    mas_producto=input('Diga si el cliente realizara otra compra:\n "1" si es si\n "2" si es no \n');
    importe=cantidad*costo;
    subtotal=subtotal+importe;
    if mas_producto==2
        i=2; 
    end;
    if importe==0
        i=2;
    end;
end;
if (subtotal> 5000)&(subtotal<= 12000)
    descuento=subtotal*0.15;
    total=subtotal-descuento;
    clc;
    fprintf('\t\t\t\t\t\t\t%s %s SU %s CON LOS PRECIOS MAS BAJOS\n',tipo_de_negocio,propetario,tipo_de_negocio);
    fprintf('/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/-*/*-*/*-*/*-*/*-*/*-*/*-/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*\n');
    fprintf('\n\n\n');
    fprintf('\t\t\t%s USTED RECIBE UN DESCUENTO DEL 15%%\n\n', nombre_del_cliente);
    fprintf('\t\t\t  El MONTO ES:  %.2f\n\n', total);
elseif subtotal>12000
    descuento=subtotal*0.20;
    total=subtotal-descuento;
    clc;
    fprintf('\t\t\t\t\t\t\t%s %s SU %s CON LOS PRECIOS MAS BAJOS\n',tipo_de_negocio,propetario,tipo_de_negocio);
    fprintf('/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/-*/*-*/*-*/*-*/*-*/*-*/*-/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*\n');
    fprintf('\n\n\n');
    fprintf('\t\t\t%s USTED RECIBE UN DESCUENTO DEL: 20%%\n\n', nombre_del_cliente);
    fprintf('\t\t\t  El MONTO ES:   %.2f\n\n', total);
else
    descuento=0;
    total=subtotal-descuento;
    clc;
    fprintf('\t\t\t\t\t\t\t\t %s %s SU %s CON LOS PRECIOS MAS BAJOS\n',tipo_de_negocio,propetario,tipo_de_negocio);
    fprintf('/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/-*/*-*/*-*/*-*/*-*/*-*/*-/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*-*/*\n');
    fprintf('\n\n\n');
    fprintf('\t\t\t%s LO SENTIMOS MUCHO PERO NO RECIBE DESCUENTO\n\n', nombre_del_cliente);
    fprintf('\t\t\t  EL MONTO ES:   %.2f\n\n', total);
end;
fprintf('\t\t\t\t GRACIAS POR SU COMPRA... %s\n\n', nombre_del_cliente);
fprintf('\t\t\t\t QUE PASE UN BUEN DIA..\n\n\n\n\n\n\n\n\n');
fprintf('\t\t\t ¿Hay mas clientes?\n\n');
fprintf('\t');
mas_clientes=input(' "1" si es si\n     "2" si es no\n');
if (mas_clientes==2)
    j=0;
end;
suma_total=suma_total+total;
end;
clc;
fprintf('La suma total de los importes cobrados con sus respectivos descuentos asciende a: %.2f \n\n\n\n\n\n\n',suma_total);
fprintf('\t\t\t\t\t\t\t Presione cualquier tecla para salir \n');
pause
exit
end;