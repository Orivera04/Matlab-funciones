%Imprecion de digitos en forma horaria(Laboratorio #1)
clc;
s=1;
while (s==1)
    s=2;
num=input('De un numero entero positivo no mayor de cuatros digitos\n');
if (num>=0)&(num<=2359)
    a=fix(num/100);
    b=(num/100)-a;
    c=b*100;
    if (a<10)&(c<10)
     fprintf('0%d:0%.f\n',a,c);
        elseif (a<10)&((c>=10)&(c<=59))
            fprintf('0%d:%.f\n',a,c);
        elseif (a>=10)&(c<10)
            fprintf('%d:0%.f\n',a,c);
        elseif(a>=10)&((c>=10)&(c<=59))
            fprintf('%d:%.f\n',a,c);
        else
            fprintf('Numero no establecido para formato\n');
        end;
    else
        fprintf('El numero debe estar dentro de un rango horario\n');
    end;
    pause;
    fprintf('¿Desea continuar?\n');
fprintf('Si es si digite el 1, si es no digite el 2\n');
s=input('Diga si desea continuar\n');
end;
fprintf('Realizado por:\n');
fprintf('JOSE MIGUEL HERRERA SUAREZ Y OSMELL DARELL GUTIERREZ\n');
fprintf('GRACIAS POR SU COOPERACION');
end;