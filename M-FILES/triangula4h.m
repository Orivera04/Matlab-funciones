function triangula4h(h,v,w)
%Función para triangular polígonos.
global  picos x y cruces4 n_inicial n_final;
n=numel(v);
hold on;
posi=0;
if n_final<5
    disp('Fin')
    return
end
if n_final==5
  triangula5(v,w);
  disp('Fin de la triangulación')
  return
end 
cruces4=0;
for k=h:2:n-5
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    cortePR=intersec1(P,R,x,y);
    corteRQ=intersec1(R,Q,x,y);
    corteQP=intersec1(Q,P,x,y);
    A=cortePR==1;B=corteRQ==1;C=corteQP==1
    if A==1|B==1|C==1
        cruces4=cruces4+1
       continue
    end
    isinter=interior3(P,Q,R,v,w);
    pint=isinter;
    pos=posicion2(P,Q,R);
    if pos==1
       if pint==0
             plot([P(1),Q(1)],[P(2),Q(2)],'g')
             posi(k)=k+1;
       end
    end 
end

clc;
picos=posi(posi~=0)
v(picos)=[];w(picos)=[];
n_inicial=n
n_final=n-numel(picos)