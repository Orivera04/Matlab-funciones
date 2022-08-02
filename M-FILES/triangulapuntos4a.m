function triangulapuntos4a(v,w)
%Función para triangular polígono.
global picos; 
clear posi;
n=numel(v);
hold on;
if n<=5
  triangula5(v,w);
  disp('Fin de la triangulación');
  return
end
posi=0;
for k=1:2:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    %A=[v(k),w(k)];
    %B=[v(k+2),w(k+2)];
    %C=[v(k+1),w(k+1)];
    %pint=interior2a(A,B,C,t,u);
    pos=posicion2(P,Q,R);
    if pos==1
      plot([P(1),Q(1)],[P(2),Q(2)],'k')
      posi(k)=k+1;
    end 
end
clc;
picos=posi(posi~=0)
v(picos)=[];w(picos)=[];n
n_inicial=n
n_final=n-numel(picos)