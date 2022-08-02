%Dibuja diagonales del poligono
[v,w]=dibujapuntos;
m=length(v);
P=[v(2),w(2)];
Q=[v(1),w(1)];
R=[v(3),w(3)];
pos=posicion(P,Q,R);
pos
hold on;
if pos==2
    plot([v(1),v(3)],[w(1),w(3)]);
end
for j=4:m-1
xa=v(1);
xm=v(j-1);
xp=v(j);
ya=w(1);
ym=w(j-1);
yp=w(j);
P=[xm,ym];
Q=[xa,ya];
R=[xp,yp];
pos=posicion(P,Q,R);
if pos==1
    plot([xa,xp],[ya,yp]);
end
end