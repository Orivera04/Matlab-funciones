%ana lucia gutierrez palacio 
%keith yasira aburto zamora
clc; 
cont=1;
 while (cont~=0)
     nombre=input('de el nombre','s');
     veces=0; suma=0;
     nota=1;
    while (nota > 0)
        nota=input('de la nota');
        veces=veces+1; suma=suma+nota;
    end;prom=suma/veces;
    fprintf('\n el nombre de la personaes %s\n\n,el promedio es%.2f\n\n',nombre,prom);
    cont=input('¿mas alumnos? si(1) no(2):');
end

