%Elizabeth Almanza Canales y Ammy Alfaro Caracas.
% Disfrute su compra.
clc
s=0; %importe total
im=0; %importe con descuento
c=input('De la compra parcial del cliente: ');
    while(c>=0)
        if(c>=5000)&(c<12000)
        im=c-(c*0.15);
        fprintf('El importe total del cliente es %.4f\n',im);
        else(c>12000)
        im=c-(c*0.2);
        fprintf('El importe total del cliente es %.4f\n',im);
        end
    s=s+im
    i=input('Mas clientes\n 1_si    2_No');
    if (i==1)
        c=input('De la compra parcial del cliente: ');
    else 
        if(i==2)
            break;
        end
    end
end
fprintf('La suma total de todos los importes es %4f\n\n',s);