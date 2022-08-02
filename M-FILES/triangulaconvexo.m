function [v,w]=triangulaconvexo()
clear,clc, clf, hold off
axis([0,10,0,10]);
hold on;
plot([1,2,2,1,1],[2,2,3,3,2]);
text(1,1.6,'Haga clic dentro del cuadro para terminar')
i=0;
while 1
[x,y,boton]=ginput(1);
if boton ==1, plot(x,y,'+r');i=i+1;v(i)=x;w(i)=y;end;
if boton ==2, plot(x,y,'oy');end;
if boton ==3, plot(x,y,'*g');end;
if x>1 & x<2 & y>2 & y<3,break; end
end
hold off
close
n=i;
v(i)=v(1);
w(i)=w(1);
plot(v,w);
hold on; %Hasta aquí, no cambiar.
%Dibujo del polígono.
global n area No_diagonales No_triangulos
for k=1:n-3
    P=[v(1),w(1)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    S=[v(k),w(k)];
    pos1=posicion2(P,Q,R)
    pos2=posicion2(S,Q,R)
    if pos1==1&pos2==1
      continue
    else
        error('Polígono no convexo')
    end
end
diagonal3(v,w);
area=areapol(v,w);
No_diagonales=n-4;
No_triangulos=n-3;
