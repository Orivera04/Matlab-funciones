clc,clear all,close all
A=[0 1 0 0;0 0 -.49 0;0 0 0 1;0 0 10.29 0];
B=[0 .2 0 -.2]';
C=[1 0 0 0;0 0 1 0];
S=ss(A,B,C,0);
K=acker(A,B,[-1.25+2.0532j -1.25-2.0532j -6.25 -6.25]);
Ar=A-B*K;
Sr=ss(Ar,zeros(4,1),C,0);
X0=[0 0 -.15 0]';
[y1,t1,x1]=initial(S,X0,0:.01:5);
[y2,t2,x2]=initial(Sr,X0,0:.01:5);
plot(t1,x1),grid
figure,plot(t2,x2);grid
%Animacion del Pendulo sin controlar
figure,carro(x1(1:200,3),x1(1:200,1),1,[],[-1,4])
clc,disp('Pulsa una tecla para ver la siguiente simulacion')
pause
%Animacion del Pendulo Controlado
figure,carro(x2(:,3),x2(:,1),1,-K*x2',[-1,4])