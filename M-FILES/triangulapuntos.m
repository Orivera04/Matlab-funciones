function [v,w]=triangulapuntos()
clear,clc, clf, hold off
global picos x y m numver  n_inicial n_final;
%Comienza dibujo del pológono.
%--------------------------------------------------------
axis([0,10,0,10]);grid on;hold on;
plot([0,1,1,0,0],[0,0,1,1,0]);text(0.3,0.5,'clic');
i=0;
while 1
[x,y,boton]=ginput(1);
if boton ==1, plot(x,y,'+r');i=i+1;v(i)=x;w(i)=y;end;
if boton ==2, plot(x,y,'oy');end;
if boton ==3, plot(x,y,'*g');end;
if x>0 & x<1 & y>0 & y<1,break; end
end
corta=intersec(v,w);
    if corta==1
        error('El polígono se corta a si mismo')
    end
hold off;close;
n=i;v(i)=v(1);w(i)=w(1); numver=i;x=v;y=w;plot(v,w);hold on;
%Finaliza dibujo del polígono.
%------------------------------------------------------------
global picos m n_inicial n_final; 
posi=0;cruces=0;
for k=1:2:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    cortePR=intersec1(P,R,x,y);
    corteRQ=intersec1(R,Q,x,y);
    corteQP=intersec1(Q,P,x,y);
    A=cortePR==1;B=corteRQ==1;C=corteQP==1
    if A==1|B==1|C==1
        cruces=cruces+1;
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
picos=posi(posi~=0);v(picos)=[];w(picos)=[];n_inicial=n;n_final=n-numel(picos);
%Aplicacion de triangulapuntos4 y triangulapuntos42
m=0;
while n_final>5 
  triangulapuntos4(v,w); v(picos)=[]; w(picos)=[];
  triangulapuntos42(v,w);v(picos)=[];w(picos)=[];
  m=m+1
  if m>numver
      break
  end
end
%Aplicacion de triangula5
if n_final<=5
  triangula5(v,w);
  disp('Fin de la triangulación')
end
%Impresión de vértices iniciales.
disp('Vértices iniciales [i,v(i),w(i)]: ')
v=x';w=y';n=numel(v);
fprintf(' i     v(i)     w(i)\n')
for i=1:n
    fprintf('%2d   %5.4f   %5.4f \n',i,v(i),w(i))
end