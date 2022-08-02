%animacion

%paso
paso=6*pi/180;
%nuero de puntos
nc=100;
%datos
t1=pi/4;
%estimaciones
x=70;
t2=30*pi/180;
%definicion de los vecotres para guardar los puntos
X=[0,0,0];
Y=X;
XP=[0,0,0,0,0];
YP=XP;
%calculo para cada posicion
for i=1:nc
    [xx,yy,x,t2] = blogpiston(t1,x,t2);
    X(i,:)=xx;
    Y(i,:)=yy;
    t1=t1+paso;
    %cuadrado para simular piston (Es para que se vea bonito )
    [xx,yy]=cuad(xx(3),yy(3),5,0);
    XP(i,:)=xx;
    YP(i,:)=yy;
    %
end
%grafico/animacion
for i=1:nc

    %Marco para la pantalla
    plot(-100,-100)
    hold on
    plot(100,100)
    
    %malla
    plot(X(i,:),Y(i,:),'-o')
    %cuadrado piston
    plot(XP(i,:),YP(i,:))
    %tiempode pausa
    pause(.1)
    hold off

end
