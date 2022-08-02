%Dibujo de  de una cónica y su traslación
%Ec. general Ax^2+By^2+Cx+Dy+F=0. Traslación: [h,k]

%Leer los coeficientes A,B,C,D,F 
Coef=input('Dar los coeficientes [A,B,C,D,F]= ');
A=Coef(1);B=Coef(2);C=Coef(3);D=Coef(4);F=Coef(5);
syms x y 
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
    %Ecuaciones de las cónicas anteriores
    ec1=x^2/a+y^2/b-1;
    ec2=(x-h)^2/a+(y-k)^2/b-1;
    ecua=f*(x^2/a+y^2/b);
    strcat(char(ecua),'=',num2str(f))
    h1=ezplot(ec1);
    set(h1,'LineColor', 'b');
    title(strcat(char(ec1),'=0'))
    hold on;
    h2=ezplot(ec2);
    set(h2,'LineColor', 'r');
    title(strcat(char(ec1),'=0'))
    grid on;
   elseif A~=0 & B==0
    disp('La cónica es una parábola con ecuación:');
    h=C/(2*A);k=F/D-C^2/(4*A*D); p=A/D;
    ec1=y+p*x^2;
    ec2=(y-k)+p*(x-h)^2
    strcat(char(ec1),'=0')
    h1=ezplot(ec1);
    set(h1,'LineColor', 'b');
    hold on;
    h2=ezplot(ec2);
    set(h2,'LineColor', 'r');
    title(strcat(char(ec1),'=0'));
    grid on;
elseif A==0 & B~=0
    disp('La cónica es una parábola con ecuación:');
    h=D/(2*B); k=F/C-D^2/(4*B*C); p=B/C;
    ec1=x+p*(y)^2;
    ec2=(x-h)+p*(y-k)^2
    strcat(char(ec1),'=0')
    h1=ezplot(ec1);
    set(h1,'LineColor', 'b');
    hold on;
    h2=ezplot(ec2);
    set(h2,'LineColor', 'r');
    title(strcat(char(ec1),'=0'));
    grid on;
end