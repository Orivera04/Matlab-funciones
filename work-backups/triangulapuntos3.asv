function [v,w]=triangulapuntos3()
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
global picos n_inicial n_final; 
posi=0;
for k=1:2:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    %pint=interior2(P,Q,R,v,w)
    isinter=interior3(P,Q,R,v,w);
    pint=isinter;
    pos=posicion2(P,Q,R);
    if pos==1
        if pint==0
          plot([P(1),Q(1)],[P(2),Q(2)],'r')
          posi(k)=k+1;
        end
    end 
end
%clc;
picos=posi(posi~=0) 
v(picos)=[];w(picos)=[]
n_inicial=n
n_final=n-numel(picos)





