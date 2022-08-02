%CP 4, Problema 2
clccontvar=0;
contmuj=0;
sumedadvar=0;
sumedadmuj=0;
mayedadvar=0;
mayedadmuj=0;
while 1
    clc
    nombre=input('¿Cual es el nombre?: >> ','s');
    if nombre=='*'
        break;
    else
        sexo=input('¿Cual es el sexo? V(varon) o M(mujer): >> ','s');
        edad=input('¿Cual es la edad?: >> ');
        switch sexo
            case {'V','v'}
                contvar=contvar+1;
                sumedadvar=sumedadvar+edad;
                if mayedadvar<edad
                    mayedadvar=edad;
                    nommayvar=nombre;
                end
            case{'M','m'}
                contmuj=contmuj+1;
                sumedadmuj=sumedadmuj+edad;
                if mayedadmuj<edad
                    mayedadmuj=edad;
                    nommaymuj=nombre;
                end
        end
    end
end
fprintf('---------------------------------------------');
fprintf('\nEL PROMEDIO DE EDAD DE VARONES ES     %d\n',sumedadvar/contvar);
fprintf('EL PROMEDIO DE EDAD DE MUJERES ES     %d\n',sumedadmuj/contmuj);
fprintf('\nNOMBRE DEL HOMBRE DE MAYOR EDAD:      %s\n',nommayvar);
fprintf('EDAD DEL HOMBRE DE MAYOR EDAD:        %d\n',mayedadvar);
fprintf('NOMBRE DE LA MUJER DE MAYOR EDAD:     %s\n',nommaymuj);
fprintf('EDAD DE LA MUJER DE MAYOR EDAD:       %d\n',mayedadmuj);