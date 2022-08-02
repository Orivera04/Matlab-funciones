%CP 4, Problema 2
clc
potencia=1;
base=input('¿Cual es la base?: >>');
expon=input('¿Cual es el exponente?: >>');
if (base==0)&(expon==0)
    fprintf('DATOS ERRONEOS');
elseif (base~=0)&(expon==0)
    fprintf('POTENCIA = %d',potencia);
elseif expon>0
    for i=1:expon
        potencia=potencia*base;
    end
    fprintf('POTENCIA = %d',potencia);
elseif expon<0
    if base==0
        fprintf('DATOS ERRONEOS',potencia);
    else
        expon=(-1)*expon;
        for i=1:expon
            potencia=potencia*base;
        end
        fprintf('POTENCIA = 1/%d',potencia);
    end
end