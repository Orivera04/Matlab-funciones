%Gráfica de una función periódica
clear all;
clc;
T=input('Longitud del período de la fn.: ');
disp('Digitar 1 si 1er período es [0,T]');
disp('Digitar 2 si 1er período es [-T/2,T/2]');
per1=input('1 o 2:->');
if per1==1
    xmin=0;xmax=T;
else
    xmin=-T/2;xmax=T/2;
end
h=0.01;
n=input('No. de períodos en que se va a graficar la función: '); 
x=xmin:h:xmax;v=x;
fun=input('f(x)=','s');
f=inline(fun);
y=f(v);
;maxy=max(y);miny=min(y);
m=input('desfase #per.: ');
x=x+m*T;
minx=min(x);
plot([minx,minx],[miny,maxy],'--k')
hold on;
for i=1:n
plot(x,y)
x=x+T;
end
maxx=max(x);a=min(0,minx);
plot([a,maxx],[0,0],'r')
plot([0,0],[-maxy,maxy],'r')
plot([maxx-T,maxx-T],[miny,maxy],'--k')
shg;
grid on
hold off
