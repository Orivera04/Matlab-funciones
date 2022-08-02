%Ec. canónicas de las cuádricas A*x^2+B*y^2+C*z^2+D*x+E*y+F*z+G
clear;clc;
syms x y z x1 y1 z1 ;
Coef=input('Coeficientes de la EG:[A B C D E F G]= '); 
A=Coef(1); B=Coef(2); C=Coef(3);D=Coef(4);E=Coef(5);F=Coef(6);G=Coef(7);
if A==0 & B==0 & C==0 
    disp('La EG no representa una cuádrica');
    break
end
%Traslación hacia el origen:x=x1+h, y=y1+k,z=z1+m.
%Sustituir en la ec. gral.: x1+h, y=y1+k,z=z1+m y encontrar
%h,k,m de tal manera que se hagan cero los terminos de 1er. grado.
%ecua=A*(x+h)^2+B*(y+k)^2+C*(z+m)^2+D*x+E*y+F*z+G
%A*h+D=0, 2*B*k+E=0, 2*C*m+F=0, s=A*h^2+B*k^2+C*m^2+G.
%Cónica trasladada:A*x1^2+B*y1^2+C*z1^2+s=0. CV:.conj. vacío.
%ecua_original=A*x1^2+B*y1^2+C*z1^2+d*x1+e*y1+f*z1+G;
if A~=0, h=-1/2/A*D, else, h=0,end
if B~=0, k=-1/2/B*E, else, k=0,end
if C~=0, m=-1/2/C*F, else, m=0,end
d=D;e=E;f=F;P=A*B*C;
s=A*h^2+B*k^2+C*m^2+D*h+E*k+F*m+G

%OPCION P>0
if P>0
    D=0;E=0;F=0;
    Q=A>0&B>0&C>0;R=A*B<0|A*C<0|B*C<0;T=s<0;U=s==0;V=s>0;
    if Q&T
        disp('La EG representa un elipsoide o una esfera')
    elseif Q&U
        disp('La EG representa un punto')
    elseif Q&V
        disp('La EG representa CV')
    elseif R&T 
        disp('La EG representa hiperboloide de dos hojas')
    elseif R&U
        disp('La EG representa un cono')
    elseif R&V 
       disp('La EG representa hiperboloide de una hoja')
    end
    
%OPCION P<0
elseif P<0 
  D=0;E=0;F=0; 
  Q=A<0|B<0|C<0;T=s<0;U=s==0;V=s>0;
  if Q&T    
     disp('La EG representa hiperboloide de una hoja')
  elseif Q&U
     disp('La EG representa un cono')
  elseif Q&V  
     disp('La EG representa un hiperboloide de dos hojas') 
  end
  
%OPCION P=0
elseif P==0 
    %PRIMER CASO DE LA OPCION P=0.
    if A==0 & B==0 & C==0 
       if D~=0|E~=0|C~=0
          disp('La EG representa un plano') 
       elseif D==0&E==0&C==0&s==0
         disp('La EG representa todo el plano XY') 
       elseif D==0&E==0&C==0&s~=0
         disp('La EG representa el CV')  
       end
       
    %SEGUNDO CASO DE LA OPCION P=0.  
    elseif A*B>0 | A*C>0 | B*C>0  
        if A*B>0,D=0;E=0;end; if A*C>0,D=0;F=0;end; if B*C>0,E=0;F=0;end;
        if (C==0&F==0&s==0)|(B==0&E==0&s==0 )|(A==0&D==0&s==0 )  
           disp('La EG representa un punto'); 
           elseif (C==0&F==0&s>0)|(B==0&E==0&s>0)|(A==0&D==0&s>0)
           disp('La EG representa CV');  
         elseif (C==0&F==0&s<0)|(B==0&E==0&s<0)|(A==0&D==0&s<0)
             disp('La EG representa un cilndro elíptico o circular')
         elseif C==0&F~=0 |B==0&E~=0 |A==0&D~=0 
           disp('La EG representa un paraboloide elíptico')  
        end
        
    %TERCER CASO DE LA OPCION P=0.   
    elseif A*B<0 | A*C<0 | B*C<0  
       if A*B<0,D=0;E=0;end; if A*C<0,D=0;F=0;end; if B*C<0,E=0;F=0;end;
       if (C==0&F==0&s==0)|(B==0&E==0&s==0 )|(A==0&D==0&s==0 )  
           disp('La EG representa dos planos que se cortan')
         elseif (C==0&F==0&s~=0)|(B==0&E==0&s~=0)|(A==0&D==0&s~=0)
           disp('La EG representa un cilindro hiperbólico')  
         elseif C==0&F~=0 |B==0&E~=0 |A==0&D~=0 
           disp('La EG representa un paraboloide hiperbólico') 
       end 
       
    %CUARTO CASO DE LA OPCION P=0.  
    elseif B==0&C==0 | A==0&C==0 | A==0&B==0  
        if A~=0,D=0;end;if B~=0,E=0;end;if C~=0,F=0;end;
        if (A~=0)&E*F~=0|(B~=0)&D*F~=0|(C~=0)&D*E~=0
            disp('La EG representa un cilindro parabólico rotado')
        elseif (A~=0)&(E==0&F~=0|F==0&E~=0)|(B~=0)&(D~=0&F==0|D==0&F~=0)|(C~=0)&(D~=0&E==0|D==0&E~=0)
            disp('La EG representa un cilindro parabólico')    
        elseif (A~=0)&(E==0&F==0)|(B~=0)&(D==0&F==0)|(C~=0)&(D==0&E==0)
            if s<0
               disp('La EG representa dos planos') 
            elseif s>0
               disp('La EG representa CV')
            elseif s==0
               disp('La EG representa un plano') 
            end 
        end 
    end 
end 

%ECUACION ORIGINAL Y ECUACION DE CUADRICA TRASLADADA
ecua1 = char(A*x^2+B*y^2+C*z^2+d*x+e*y+f*z+G);
ecua2=char(A*x1^2+B*y1^2+C*z1^2+D*x1+E*y1+F*z1+s);
ecuacion_original=strcat(ecua1,'=0')
ecuacion_trasladada=strcat(ecua2,'=0')