function [v,w]=triangula1()
clear,clc, clf, hold off
global picos x y m cruces cruces1 cruces2 cruces3 numver  n_inicial n_final;
axis([-1,10,-1,10]);grid on;
hold on;
plot([-1,0,0,-1,-1],[0,0,3,3,0],'r');
plot([0,10,10,0,0],[0,0,10,10,0],'r');
text(-0.7,2.5,'dar'); text(-0.7,1.5,'clic');text(-0.7,0.5,'aquí');
i=0;
while 1
[x,y,boton]=ginput(1);
if boton ==1, plot(x,y,'+r');i=i+1;v(i)=x;w(i)=y;end;
if boton ==2, plot(x,y,'oy');end;
if boton ==3, plot(x,y,'*g');end;
if x>-1 & x<0 & y>0 & y<3,break; end
end
hold off
close
n=i;numver=numel(v);
v(i)=v(1);
w(i)=w(1);
plot(v,w);
x=v;y=w;
corta=intersec(v,w);
    if corta==1
        error('El polígono se corta a si mismo')
    end
x=v;y=w;
hold on; 
%hasta aquí dibujo del polígono.
posi=0;
cruces1=0;
for k=1:2:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)]; 
    cortePR=intersec1(P,R,x,y);
    corteRQ=intersec1(R,Q,x,y);
    corteQP=intersec1(Q,P,x,y);
    A=cortePR==1;B=corteRQ==1;C=corteQP==1
    if A==1|B==1|C==1
        cruces1=cruces1 +1;
       continue
    end
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
clc;
picos=posi(posi~=0)
v(picos)=[];w(picos)=[];
n_inicial=n
n_final=n-numel(picos)

%Aplicacion de triangula2 y triangula3
m=0;iter=numver;
while n_final>5 
  triangula2(v,w);
  v(picos)=[];
  w(picos)=[];
  triangula3(v,w);
  v(picos)=[];
  w(picos)=[];
  m=m+1;
  if m>iter
      break
  end
end
if n_final<=5
   triangula5(v,w);
   disp('Fin de la triangulación')
end    
cruces=cruces1+cruces2+cruces3;
disp('Vértices iniciales [i,v(i),w(i)]: ')
v=x';w=y';n=numel(v);
fprintf(' i     v(i)     w(i)\n')
for i=1:n
    fprintf('%2d   %5.4f   %5.4f \n',i,v(i),w(i))
end
