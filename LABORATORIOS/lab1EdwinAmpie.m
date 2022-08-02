clc;
%Imprecion de digitos en forma horaria
%EDWIN AMPIE
num=input('De un numero entero positivo no mayor de cuatros digitos\n');
if (num>=0)&(num<=2359)
    a=fix(num/100);
    b=((num/100)-a);
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
            fprintf('Numero no establecido para formaato\n');
        end;
    else
        fprintf('El numero debe estar dentro de un rango horario\n');
    end;
end;