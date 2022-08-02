%Hallar el centro y el radio de una circunferencia dada la ecuación 
%genral Ax^2 + Cy^2 + Dx *Ey +F=0
clear;
clc

%Introducir los coeficientes de la ecuación general(A y C no-negativos) :
A=input('Dar coefieciente A: ');
C=input('Dar coefieciente C: ');
if A<=0 | C<=0
    disp('La ecuación no representa una circuneferncia');
break;
end

D=input('Dar coefieciente D: ');
E=input('Dar coefieciente E: ');
F=input('Dar coefieciente F: ');
disp('Ecuación General');
fprintf('x^2+y^2%+dx%+dy %+d = 0\n',D,E,F)
h=D/2;
k=E/2;

%Comprobar si la ecuación general representa una circunferencia
if A==C
    if A==1 
        if h^2+k^2-F>0
            disp('La ecuación representa una circunferencia');
            rcuad=h^2+k^2-F;
            fprintf('(x %+4.2f)^2 + (y %+4.2f)^2 = %4.2f\n',h,k,rcuad)
        else
            disp('La ecuación no representa una circunferencia');
        end
    else
        C=C/A;D=D/A;E=E/A;F=F/A;
        h=-D/2;k=-E/2;
        if h^2+k^2-F>0
            disp('La ecuación representa una circunferencia');
            rcuad=-F+h^2+k^2;
            fprintf('(x %+4.2f)^2 + (y %+4.2f)^2 = %4.2f\n',h,k,rcuad)
        else
            disp('La ecuación no representa una circunferencia');
        end
    end
else
    disp('La ecuación no reprenta una circunferencia');
end
    



