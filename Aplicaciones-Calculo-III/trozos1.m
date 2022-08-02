%Gráfica de una función a definida a trozos

clear all;
clc;
minx=input('Dar extremo izq. del intervalo [a,b]: ');
maxx=input('Dar extremo der. del intervalo [a,b]: ');
h=input('Dar el paso h: ');
x=minx+h;
hold on;
i=1;
while x>=minx & x<=maxx  
disp(['subintervalo # ',num2str(i)]);
xmin=input('Dar xmin del subintervalo: ');
xmax=input('Dar xmax del subintervalo: ');
    x=xmin:h:xmax;
    y=input('fun(x)=');
    x=xmin;
    y1=eval(y);
    x=xmax;
    y2=eval(y);
    plot([xmin,xmin],[0,y1],':r')
    fplot(y,[xmin xmax]);
    axis tight
    %x=xmin;
    %y1=eval(y);
    %x=xmax;
    %y2=eval(y);
    %plot([xmax,xmax],[y1,y2],':r')
    x=xmax+0.01;
    i=i+1;
end
shg
hold off
