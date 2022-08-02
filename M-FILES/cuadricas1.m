%Ec. canónicas de las cuádricas A*x^2+B*y^2+C*z^2+D*x+E*y+F*z+G
%ecua=input('Ecuación General: ');
clc;
syms x y z x1 y1 z1 ;
Coef=input('Coeficientes de la EG:[A B C D E F G]= '); 
A=Coef(1) ;B=Coef(2);C=Coef(3);D=Coef(4);E=Coef(5);F=Coef(6);G=Coef(7);
%Traslación hacia el origen:x=x1+h, y=y1+k,z=z1+m.
%Sustituir en la ec. gral.: x1+h, y=y1+k,z=z1+m y encontrar
%h,k,m de tal manera que se hagan cero los terminos de 1er. grado.
%ecua=A*(x+h)^2+B*(y+k)^2+C*(z+m)^2+D*x+E*y+F*z+G
%A*h+D=0, 2*B*k+E=0, 2*C*m+F=0, s=A*h^2+B*k^2+C*m^2+G.
%Cónica trasladada:A*x1^2+B*y1^2+C*z1^2+s=0. CV:.conj. vacío.
%if A<0
%A=-A ;B=-B;C=-C;D=-D;E=-E;F=-F;G=-G;  
%end
%h=-1/2/A*D; k=-1/2/B*E; m=-1/2/C*F; s=A*h^2+B*k^2+C*m^2+D*h+E*k+f*m+G
P=A*B*C;
if P>0
    h=-1/2/A*D; k=-1/2/B*E; m=-1/2/C*F; 
    s=A*h^2+B*k^2+C*m^2+G;
    if s>0
    ecuatras=A/s*x1^2+B/s*y1^2+C/s*z1^2+1
    elseif s<0
    ecuatras=-1*(A/s*x1^2+B/s*y1^2+C/s*z1^2+1)
    else
    ecuatras=A*x1^2+B*y1^2+C*z1^2
    end
    if B>0 & s<0
        disp('La EG representa un elipsoide o esfera')
    elseif B>0 & s==0
        disp('La EG representa un punto')
    elseif B>0 & s>0
        disp('La EG representa CV')
    elseif B<0 & s>0
        disp('La EG representa hiperboloide de una hoja')
    elseif B<0 & s==0
        disp('La EG representa un cono')
    elseif B<0 & s<0 
       disp('La EG representa hiperboloide de dos hojas')
    end

elseif P<0  
    h=-1/2/A*D; k=-1/2/B*E; m=-1/2/C*F; 
    s=A*h^2+B*k^2+C*m^2+G;  
   if s>0  
     ecuatras=A/s*x1^2+B/s*y1^2+C/s*z1^2+1
   elseif s<0
     ecuatras=-1*(A/s*x1^2+B/s*y1^2+C/s*z1^2+1)
   else
     ecuatras=A*x1^2+B*y1^2+C*z1^2
   end 
   if     B>0 & s<0
     disp('La EG representa hiperboloide de una hoja')
   elseif B>0 & s>0
     disp('La EG representa un hiperboloide de dos hojas')
   elseif B<0 & s<0
     disp('La EG representa hiperboloide de una hoja')
   elseif B<0 & s>0  
     disp('La EG representa un hiperboloide de dos hojas') 
   elseif C>0 & s<0
      disp('La EG representa hiperboloide de una hoja')
   elseif C>0 & s>0  
      disp('La EG representa un hiperboloide de dos hojas')
   elseif C<0 & s<0
      disp('La EG representa hiperboloide de una hoja')
   elseif C<0 & s>0  
      disp('La EG representa un hiperboloide de dos hojas')
   elseif B*C<0 & s==0
      disp('La EG representa un cono')   
   end
  
%Casos donde A=0 o B=0 o C=0
elseif P==0
    if A==0 & B==0 & C==0
       disp('La EG representa el CV') 
    elseif A*B>0
         h=-1/2/A*D; k=-1/2/B*E; 
         s=A*h^2+B*k^2+F*m+G;
         ecuatras=A*x1^2+B*y1^2+F*z1+s
         if F==0 & G==0
           disp('La EG representa un punto') 
         elseif F==0 & G>0
           disp('La EG representa un cilindro hiperbólico')  
         elseif F==0 & G<0
           disp('La EG representa CV')
         elseif F~=0 
           disp('La EG representa un parabolide elíptico')  
         end
    elseif A*B<0
         h=-1/2/A*D; k=-1/2/B*E; 
         s=A*h^2+B*k^2+F*m+G;
         ecuatras=A*x1^2+B*y1^2+F*z1+s
         if F==0 & G==0
           disp('La EG representa dos planos que se cortan') 
         elseif F==0 & G~=0
           disp('La EG representa un cilindro hiperbólico')  
         elseif F~=0 
           disp('La EG representa un parabolide hiperbólico')  
         end
    elseif A*C>0
        h=-1/2/A*D; m=-1/2/C*F;
        s=A*h^2+C*m^2+E*k+G;
        ecuatras=A*x1^2+C*z1^2+By1+s
        if F==0 & G==0
           disp('La EG representa un punto') 
         elseif F==0 & G>0
           disp('La EG representa un cilindro hiperbólico')  
         elseif F==0 & G<0
           disp('La EG representa CV')
         elseif F~=0 
           disp('La EG representa un parabolide elíptico')  
         end
    elseif A*C<0 
         h=-1/2/A*D; m=-1/2/C*F;
         s=A*h^2+C*m^2+E*k+G;
         ecuatras=A*x1^2+C*z1^2+By1+s
         if F==0 & G==0
           disp('La EG representa dos planos que se cortan') 
         elseif F==0 & G~=0
           disp('La EG representa un cilindro hiperbólico')  
         elseif F~=0 
           disp('La EG representa un parabolide hiperbólico')  
         end
    elseif B*C>0 
        k=-1/2/B*E; m=-1/2/C*F;
        s=B*k^2+C*m^2+D*h+G;
        ecuatras=B*y1^2+C*z1^2+D*x1+s
        if F==0 & G==0
           disp('La EG representa un punto') 
        elseif F==0 & G>0
           disp('La EG representa un cilindro hiperbólico')  
        elseif F==0 & G<0
           disp('La EG representa CV')
        elseif F~=0 
           disp('La EG representa un parabolide elíptico')  
        end
        elseif B*C<0
           k=-1/2/B*E; m=-1/2/C*F;
           s=B*k*2+C*m^2+D*h+G
           ecuatras=B*y1^2+C*z1^2+D*x1+s
           if F==0 & G==0
           disp('La EG representa dos planos que se cortan') 
           elseif F==0 & G~=0
           disp('La EG representa un cilindro hiperbólico')  
           elseif F~=0 
           disp('La EG representa un parabolide hiperbólico')  
           end
    elseif A==0 & B==0 
        m=-1/2/C*F; s=C*m^2+F*m+G; ecuatras=C*z1^2+Dx1+E*y1+s
        if D*E~=0
            disp('La EG representa un cilindro parabólico rotado')
        elseif (D~=0 & E==0) | (D==0 & E~=0)
            disp('La EG representa un cilindro parabólico') 
        elseif D==0 & E==0 & s/C<0  
            disp('La EG representa dos planos')
        elseif D==0 & E==0 & s/C>0  
            disp('La EG representa CV')
        elseif D==0 & E==0 & s/C==0  
            disp('La EG representa un plano')    
        end
    elseif B==0 & C==0
         h=-1/2/A*D; s=A*h^2+D*h+G;
         ecuatras=A*x1^2+E*y1+s
         if E*F~=0
            disp('La EG representa un cilindro parabólico rotado')
         elseif (F~=0 & E==0) | (F==0 & E~=0)
            disp('La EG representa un cilindro parabólico') 
         elseif F==0 & E==0 & s/C<0  
            disp('La EG representa dos planos')
         elseif F==0 & E==0 & s/C>0  
            disp('La EG representa CV')
         elseif F==0 & E==0 & s/C==0  
            disp('La EG representa un plano')    
         end
      elseif A==0 & C==0
         k=-1/2/B*E;s=B*k^2+E*k+G; ecuatras=B*y1^2+D*x1+F*z1+s
         if D*F~=0
            disp('La EG representa un cilindro parabólico rotado')
         elseif (D~=0 & F==0) | (D==0 & F~=0)
            disp('La EG representa un cilindro parabólico') 
         elseif D==0 & F==0 & s/C<0   
            disp('La EG representa dos planos')
         elseif D==0 & F==0 & s/C>0  
            disp('La EG representa CV')
         elseif D==0 & F==0 & s/C==0  
            disp('La EG representa un plano')    
         end
    end
end