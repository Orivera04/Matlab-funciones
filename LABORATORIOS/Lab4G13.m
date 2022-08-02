importe=0
importet=0
while(importe>=0)
    nombre=input('De el nombre del cliente','s');
    importe=input('De la compra parcial del cliente');
    if(importe>=5000)&(importe<=12000)
        importedes=importe-(importe*(0.15))
        fprintf('El importe con 15% de descuento es %2f',importedes);
    else(importe>12000)
        importedes=importe-(importe*(0.20))
        fprintf('El importe con 20% de descuento es %2f',importedes);
    end
    fprintf('%s\n',nombre);
    importet=importet+importedes
    salir=input('Mas clientes\n S o N',s,n)
    if(salir=='s');
        break;
    end
end
fprintf('La suma de todos los importes es %2f',importet);