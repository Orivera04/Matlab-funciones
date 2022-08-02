%Angulo entre dos rectas: A1x+B1y +C1=0,  A2x+B2y +C2 =0

%Introducción de los coeficientes A1,B1,C1,A2,B2,C2 de las rectas

A1=input('Dar el coeficiente A1: ');
B1=input('Dar el coeficiente B1: ');
C1=input('Dar el coeficiente C1: ');
A2=input('Dar el coeficiente A2: ');
B2=input('Dar el coeficiente B2: ');
C2=input('Dar el coeficiente C2: ');

%Intersección de las rectas
if A1==A2 & B1==B2 & C1==C2
    disp('Las dos rectas coinciden. Angulo entre ellas es 0º');
    dibujarrecta1(A1,B1,C1);
elseif A1==A2 & B1==B2 & C1~=C2
    disp('Las rectas son paralelas')
    dibujarrecta1(A1,B1,C1);
    hold on;
    dibujarrecta1(A1,B1,C1);
    hold off
else A1~=A2 || B1~=B2 ;
    num1=B1*C2-B2*C1;
    num2=A2*C1-A1*C2;
    den=A1*B2-A2*B1;
    x=num1/den;
    y=num2/den;
    disp('Punto de intersección:');
    fprintf('x=%4.2f, y=%4.2f\n',x,y);
    cosa=abs(A1*A2+B1*B2)/(sqrt(A1^2+B1^2)*sqrt(A2^2+B2^2));
    angulo=acos(cosa)*180/pi;
    disp(['El ángulo entre las rectas es:',num2str(angulo),'º']);
    xmin=x-5;
    xmax=x+5;
    dibujarrecta(A1,B1,C1,xmin,xmax);
    hold on;
    dibujarrecta(A2,B2,C2,xmin,xmax);
    hold off
end





