 %Método de completación de cuadrados para determinar el centro de una
%elipse e hipérbola o el vértice de una parábolaapartir de la ecuación
%general Ax^2+Cy^2+Dx+Ey+F=0 (Ec. canónica:
%(x-h)^2+-/y-k)^2=1,(y-k)^2=+-4px
clc;
%Introducción de los coeficientes: A,C,D,E,F
A=input('Dar el coeficiente A: ');
C=input('Dar el coeficiente C: ');
D=input('Dar el coeficiente D: ');
E=input('Dar el coeficiente E: ');
F=input('Dar el coeficiente F: ');

%Completación de cuadrados
syms x y
if A==0 & C==0
    disp('La curva no es una cónica');
    break
end
      fprintf('\n\n');
      fprintf('\t\t\t\t\t\t\tEcuación general:');
      ecgen=A*x^2+C*y^2+D*x+E*y+F;
      eg=strcat(char(ecgen),'=0');
      pretty(sym(eg));
%Caso elipse
if A*C>0 
      d=-F+D^2/(4*A)+E^2/(4*C);
    if d<=0
      fprintf('La curva no es una cónica'); 
      break
    else
        fprintf('\n');
      fprintf('\t\t\t\t\t\t\tLa cónica es una elipse\n')
      ec=(x+D/(2*A))^2/(d/A)+(y+E/(2*C))^2/(d/C);
      fprintf('\n');
      fprintf('\t\t\t\t\t\t\tEcuación canónica:');
      ecua=strcat(char(ec),'=1');  
      pretty(sym(ecua));
    end  
    
%Caso hipérbola
elseif A*C<0
       d=-F+D^2/(4*A)+E^2/(4*C)
    if d==0
        disp('La curva no es una cónica')
        break
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tLa cónica es una hipérbola\n');
        ec=(x+D/(2*A))^2/(d/A)+(y+E/(2*C))^2/(d/C);
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuación canónica:');
        ecua=strcat(char(ec),'=1');  
        pretty(sym(ecua))
    end
%Caso parábola
elseif A*C==0
    d=C*D^2+A*E^2-4*A*C*F;
    if d==0
        disp('La curva no es una cónica')
        break
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tLa cónica es una parábola\n');
    end
    if C==0
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuación canónica:');
        partec1=(x+D/(2*A))^2;
        partec2=(-E/A)*(y+(4*A*E*F-D^2)/(4*A*E));
        ec=strcat(char(partec1),'=',char(partec2));
        ecua=sym(ec);
        pretty(ecua);
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuación canónica:');
        partec1=(y+E/(2*C))^2;
        partec2=(-D/C)*(x+(4*C*D*F-D^2)/(4*C*D));
        ec=strcat(char(partec1),'=',char(partec2));
        ecua=sym(ec);
        pretty(ecua);
    end
end





