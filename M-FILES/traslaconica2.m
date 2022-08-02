%Método de completación de cuadrados para obtener la ecuación
%canónica de una cónica apartir de la ec. general Ax^2+By^2+Cx+Dy+F=0

%Leer los coeficientes A,B,C,D,F 
Coef=input('Dar los coeficientes [A,B,C,D,F]= ');
A=Coef(1);B=Coef(2);C=Coef(3);D=Coef(4);F=Coef(5);
syms x y x1 y1
d=B*C^2+A*D^2-4*A*B*F;
if A<0 & B<0
    A=-A;B=-B;C=-C;D=-D;F=-F;
end
if (A==0&B==0)|(A*B~=0&d==0)|(A*B>0&d<0)|(A~=0&B==0&D==0)|(A==0&B~=0&C==0)
    disp('La gráfica no es una cónica');
    break
end
if A<0 & B<0
    A=-A;B=-B;C=-C;D=-D;F=-F;
end
if A~=0 & B~=0
    %Calcular las traslaciones h,k,f,a y b.
    h=C/(-2*A); k=D/(-2*B);f=A*h^2+B*k^2-F;a=f/A; b=f/B;
    if a*b>0 & a==b
     disp('La cónica es una circunferencia con ecuación:');
    elseif a*b>0 & a~=b
    disp('La cónica es una elipse con ecuación:');   
    elseif a*b<0
    disp('La cónica es una hipérbola con ecuación:');
    end
    %Ecuaciones:
    ec=((x1)^2/a+(y1)^2/b);
    ecu=strcat(char(ec),'=1');
    ecua=sym(ecu);
    pretty(ecua);
elseif A~=0 & B==0
    disp('La cónica es una parábola con ecuación:');
    h=C/(2*A);
    k=F/D-C^2/(4*A*D);
    p=A/D;
    ec=(y1)+p*(x1)^2;
    ecu=strcat(char(ec),'=0'); 
    ecua=sym(ecu);
    pretty(ecua);
elseif A==0 & B~=0
    disp('La cónica es una parábola con ecuación:');
    h=D/(2*B);
    k=F/C-D^2/(4*B*C);
    p=B/C;
    ec=(x1)+p*(y1)^2;
    ecu=strcat(char(ec),'=0'); 
    ecua=sym(ecu);
    pretty(ecua);
end
    
