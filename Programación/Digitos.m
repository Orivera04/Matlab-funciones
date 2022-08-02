%imprimir tipo horario,LABORATORIO 1
%Sheyla Samanta Castro Maltez

clc;
num=input('De un numero de cuatros digitos\n');
if (num>=0)&(num<=2359)
    x=fix(num/100);
    y=(num/100)-x;
    z=y*100;
    if (x<10)&(z<10)
     fprintf('0%d:0%.f\n',x,z);
        elseif (x<10)&((z>=10)&(z<=59))
            fprintf('0%d:%.f\n',x,z);
        elseif (x>=10)&(z<10)
            fprintf('%d:0%.f\n',x,z);
        elseif(x>=10)&((z>=10)&(z<=59))
            fprintf('%d:%.f\n',x,z);
        else
            fprintf('Numero no establecido\n');
        end;
    else
        fprintf('El numero debe estar dentro de un rango horario\n');
    end;
end;