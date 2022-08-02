clc;
% Edwin Ampie.
% Yoshua Bermudez.
clc;
i=1;
while (i~=0)
    clc;
    x=0;
    y =0;
    nombre = input('De el nombre del alumno: ','s');
    nota =0;
    while (nota >= 0)
        nota = input('De la nota del alumno: ');
        x = x + nota;
        y=y+1;
    end
    media=x/y;
    fprintf('El nombre del alumno es %s\nLa media es %.2f\n\n',nombre,media);
    i = input('Desea continuar SI(1) NO(2):' );
    if(i==2)
        
        i=0;    
    else
        i=1;
    end
end
