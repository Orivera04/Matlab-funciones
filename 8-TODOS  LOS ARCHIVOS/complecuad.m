 %M�todo de completaci�n de cuadrados para determinar el centro de una
%elipse e hip�rbola o el v�rtice de una par�bolaapartir de la ecuaci�n
%general Ax^2+Cy^2+Dx+Ey+F=0 (Ec. can�nica:
%(x-h)^2+-/y-k)^2=1,(y-k)^2=+-4px
clc;
%Introducci�n de los coeficientes: A,C,D,E,F
A=input('Dar el coeficiente A: ');
C=input('Dar el coeficiente C: ');
D=input('Dar el coeficiente D: ');
E=input('Dar el coeficiente E: ');
F=input('Dar el coeficiente F: ');

%Completaci�n de cuadrados
syms x y
if A==0 & C==0
    disp('La curva no es una c�nica');
    break
end
      fprintf('\n\n');
      fprintf('\t\t\t\t\t\t\tEcuaci�n general:');
      ecgen=A*x^2+C*y^2+D*x+E*y+F;
      eg=strcat(char(ecgen),'=0');
      pretty(sym(eg));
%Caso elipse
if A*C>0 
      d=-F+D^2/(4*A)+E^2/(4*C);
    if d<=0
      fprintf('La curva no es una c�nica'); 
      break
    else
        fprintf('\n');
      fprintf('\t\t\t\t\t\t\tLa c�nica es una elipse\n')
      ec=(x+D/(2*A))^2/(d/A)+(y+E/(2*C))^2/(d/C);
      fprintf('\n');
      fprintf('\t\t\t\t\t\t\tEcuaci�n can�nica:');
      ecua=strcat(char(ec),'=1');  
      pretty(sym(ecua));
    end  
    
%Caso hip�rbola
elseif A*C<0
       d=-F+D^2/(4*A)+E^2/(4*C)
    if d==0
        disp('La curva no es una c�nica')
        break
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tLa c�nica es una hip�rbola\n');
        ec=(x+D/(2*A))^2/(d/A)+(y+E/(2*C))^2/(d/C);
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuaci�n can�nica:');
        ecua=strcat(char(ec),'=1');  
        pretty(sym(ecua))
    end
%Caso par�bola
elseif A*C==0
    d=C*D^2+A*E^2-4*A*C*F;
    if d==0
        disp('La curva no es una c�nica')
        break
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tLa c�nica es una par�bola\n');
    end
    if C==0
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuaci�n can�nica:');
        partec1=(x+D/(2*A))^2;
        partec2=(-E/A)*(y+(4*A*E*F-D^2)/(4*A*E));
        ec=strcat(char(partec1),'=',char(partec2));
        ecua=sym(ec);
        pretty(ecua);
    else
        fprintf('\n');
        fprintf('\t\t\t\t\t\t\tEcuaci�n can�nica:');
        partec1=(y+E/(2*C))^2;
        partec2=(-D/C)*(x+(4*C*D*F-D^2)/(4*C*D));
        ec=strcat(char(partec1),'=',char(partec2));
        ecua=sym(ec);
        pretty(ecua);
    end
end





