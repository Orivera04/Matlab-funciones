%Dibuja diagonales del poligono
[v,w]=dibujapuntos;
m=length(v);
P=[v(1),w(1)];
Q=[v(2),w(2)];
R=[v(3),w(3)];
pos=posicion(P,Q,R);
hold on;
if pos==2
    plot([v(1),v(3)],[w(1),w(3)]);
end
for j=3:m-1
xa=v(1);
xm=v(j-1);
xs=v(j);
ya=w(1);
ym=w(j-1);
ys=w(j);
xp=v(j+1);
yp=w(j+1);
P=[xm,ym];
Q=[xa,ya];
R=[xs,ys];
S=[xp,yp];
pos1=posicion(P,S,Q);
pos2=posicion(P,S,R);
pos3=posicion(Q,R,P);
pos4=posicion(Q,R,S);
if pos1==pos2 | pos3==pos4
  plot([xa,xp],[ya,yp]);
end
end
