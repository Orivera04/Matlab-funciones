clc;
% Maria del Pilar Aburto Matus.
% Bayado José Matus Ruíz.
% Lab3g4
clc;
i=1;
while (i~=0)
    clc;
    s=0;
    n =0;
    nombre = input('De el nombre de la persona: ','s');
    nota =0;
    while (nota >= 0)
        nota = input('De la nota de la persona: ');
        s = s + nota;
        n=n+1;
    end
    media=s/n;
    fprintf('El nombre de la persona es %s\nLa media es %.2f\n\n',nombre,media);
    i = input('Desea continuar SI(1) NO(2): ');
    if(i==2)
        
        i=0;    
    else
        i=1;
    end
end

    