%Marlon Antonio Amador Herrera

clc;
h=input('De un numero para la hora\n');
if (h>=0) & (h<=2359);
    hh=fix(h/100);
    mm=((h/100)-hh)*100;
    if(hh>=10)&((mm>=10)&(mm<=59));
        fprintf('%d:%.f\n',hh,mm);
    elseif (hh>=10)&(mm<10);
        fprintf('%d:0%.f\n',hh,mm);
    elseif (hh<10)&((mm>=10)&(mm<=59));
        fprintf('0%d:%.f\n',hh,mm);
    elseif (hh<10)&(mm<10);
        fprintf('0%d:0%.f\n',hh,mm);
    else
        fprintf('El numero esta fuera de un rango horario\n');
    end;
else
    fprintf('El numero esta fuera de un rango horario\n');
end;