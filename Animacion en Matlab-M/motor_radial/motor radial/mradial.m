clc
clear all
hold off
%numero de calculos
nc=2%5*360/5+1;
%tiempo depausa para una imagen
dt=0.01; 
paso=pi/4%5*pi/(180);
%geometria
lm=15;%manivela
lb=45;%biela
rb=8;%radio de la biela
e=16;%ancho piston
d=3.4;%ancho biela
np=10;%numero de puntos para el calculo de la curvatura de las biela
%Valor inicial
t=0;
X=[];
Y=[];
x1=lm+lb;
% valores estimativos iniciales
x1=40;
tb=80*pi/180;
%piston2
t2=pi/8;
a2=(90-72)*pi/180;
x2=50;
% Piston3
t3=45*pi/180;
a3=54*pi/180;
x3=40;
%Piston4
t4=pi/5;
a4=a3;
x4=10;
% Piston5
t5=-30*pi/180;
a5=18*pi/180;
x5=40;

for i=1:nc
    [tb,x1] = pist1(t,tb,x1,lm,lb,rb);
    x=[0,lm*sin(t)];
    y=[0,lm*cos(t)];
    X0(i,:)=x;
    Y0(i,:)=y;
    [cx,cy]=cuad(0,x1,e,0);
    CX1(i,:)=cx;
    CY1(i,:)=cy;
    %Biela
    pm=lm*[sin(t),cos(t)];
    [ppx,ppy]=pen(pm,tb,rb);
    Px(i,:)=ppx';
    Py(i,:)=ppy';
    tt(i)=t;
    xx2(i)=x2;
    %piston1
    X1(i,:)=[ppx(1),0];
    Y1(i,:)=[ppy(1),x1];
    %piston2
    [t2,x2] = pist(ppx(2),ppy(2),t2,x2,lm,lb,rb);
    [cx,cy]=cuad(x2*cos(a2),x2*sin(a2),e,(90-72)*pi/180);
    CX2(i,:)=cx;
    CY2(i,:)=cy;
    X2(i,:)=[ppx(2),x2*cos(a2)];
    Y2(i,:)=[ppy(2),x2*sin(a2)];
    xx2(i)=x2;
    %piston3
    [t3,x3] = pist3(ppx(3),ppy(3),t3,x3,a3,lm,lb,rb);
    [cx,cy]=cuad(x3*cos(a3),-x3*sin(a3),e,pi-a3);
    CX3(i,:)=cx;
    CY3(i,:)=cy;
    X3(i,:)=[ppx(3),x3*cos(a3)];
    Y3(i,:)=[ppy(3),-x3*sin(a3)];
    xx3(i)=x3;
    %piston4
    [t4,x4] = pist4(ppx(4),ppy(4),t4,x4,a4,lm,lb,rb);
    [cx,cy]=cuad(-x4*cos(a4),-x4*sin(a4),e,a4);
    CX4(i,:)=cx;
    CY4(i,:)=cy;
    X4(i,:)=[ppx(4),-x4*cos(a4)];
    Y4(i,:)=[ppy(4),-x4*sin(a4)];
    xx4(i)=x4;
    %piston5
    [t5,x5] = pist5(ppx(5),ppy(5),t5,x5,a5,lm,lb,rb);
    [cx,cy]=cuad(-x5*cos(a5),x5*sin(a5),e,pi-a5);
    CX5(i,:)=cx;
    CY5(i,:)=cy;
    X5(i,:)=[ppx(5),-x5*cos(a5)];
    Y5(i,:)=[ppy(5),x5*sin(a5)];
    xx5(i)=x5;
    
    t=t+paso;    
    %cigueñal
    [bx0,by0] = biela(X0(i,:),Y0(i,:),d,np);
    %las bielas
    [bx2,by2] = biela(X2(i,:),Y2(i,:),d,np);
    [bx3,by3] = biela(X3(i,:),Y3(i,:),d,np);
    [bx4,by4] = biela(X4(i,:),Y4(i,:),d,np);
    [bx5,by5] = biela(X5(i,:),Y5(i,:),d,np);
    
    BX0(i,:)=bx0';
    BY0(i,:)=by0';
    
    BX2(i,:)=bx2';
    BY2(i,:)=by2';

    BX3(i,:)=bx3';
    BY3(i,:)=by3';
 
    BX4(i,:)=bx4';
    BY4(i,:)=by4';

    BX5(i,:)=bx5';
    BY5(i,:)=by5'; 
    
    %%biela Maestra
    [ppx,ppy]=pbiela(pm,tb,[ppx(1),0],[ppy(1),x1],3,10,rb);
    BPX(i,:)=ppx';
    BPY(i,:)=ppy';
end
BX=[];
BY=[];
a=[90,18,-54,-126,-198,90]*pi/180;
for i=1:6
    P = bloc(a(i),lm,lb,rb,e);
    BX=[BX P(:,1)'];
    BY=[BY P(:,2)'];
end

for i=1:nc
    plot(-100,-100)
    hold on
    plot(BX,BY,'k')%Bloc
    plot(100,100)
    plot(CX1(i,:),CY1(i,:))%CUADRADO 1
    plot(CX1(i,:),CY1(i,:))%CUADRADO 1
    plot(CX2(i,:),CY2(i,:))%CUADRADO 2
    plot(CX3(i,:),CY3(i,:))%CUADRADO 3
    plot(CX4(i,:),CY4(i,:))%CUADRADO 4
    plot(CX5(i,:),CY5(i,:))%CUADRADO 5

    plot(Px(i,:),Py(i,:),'o')%PENTAGONO
    
     plot(X0(i,:),Y0(i,:),'o')%FIGURA 0 manivela 2 puntos
     plot(X1(i,:),Y1(i,:),'o')%FIGURA 1 pasador biela princ piston 2 puntos 
     plot(X2(i,:),Y2(i,:),'o')%FIGURA 2 pasador biela princ piston 2 puntos  
     plot(X3(i,:),Y3(i,:),'o')%FIGURA 3 pasador biela princ piston 2 puntos 
     plot(X4(i,:),Y4(i,:),'o')%FIGURA 4 pasador biela princ piston 2 puntos 
     plot(X5(i,:),Y5(i,:),'o')%FIGURA 5 pasador biela princ piston 2 puntos 
     
     plot(BX0(i,:),BY0(i,:),'m')%Manivela

     plot(BPX(i,:),BPY(i,:),'r')%biela maestra
     plot(BX2(i,:),BY2(i,:))%Biela
     plot(BX3(i,:),BY3(i,:))%Biela
     plot(BX4(i,:),BY4(i,:))%Biela
     plot(BX5(i,:),BY5(i,:))%Biela
     
    hold off
    pause(dt) %Pausa dt segundos
end