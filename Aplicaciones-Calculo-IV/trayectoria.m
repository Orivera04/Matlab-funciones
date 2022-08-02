%Programa para simular el movimiento de caída libre
clc
syms t g v0 s0
y1=-(g/2)*t.^2 + v0*t + s0;
valg=input('El valor de g es g= ');
valv0=input('El valor de vo es v0= ');
vals0=input('El valor de s0 es s0= '); 
y=subs(y1,{g,v0,s0},{valg,valv0,vals0});
v=-32*t + valv0
tmax= valv0/32
ymax=subs(y,t,tmax)
plot([1 1],[0 ymax])
hold on
axis([0 tmax+2 0 ymax+2])
%plot([1.5 1.5],[0 ymax])
tiempo=0:0.1:tmax;
ynue= subs(y,t,tiempo);
n=numel(tiempo)
for i=1:n
    h=plot(1,ynue(i),'ro');
    pause(1)
    delete(h);
end
%ydes=ymax-ynue;
tiempo=tmax:-0.1:0;
ynue= subs(y,t,tiempo);
for i=1:n
    h=plot(1,ynue(i),'ro');
    pause(1)
    delete(h);
end
hold off
clear