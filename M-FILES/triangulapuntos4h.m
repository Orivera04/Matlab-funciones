function triangulapuntos4h(h,v,w)
%Función para triangular polígonos.
global picos  n_inicial n_final;
n=numel(v);
hold on;
posi=0;
for k=h:2:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    isinter=interior4(P,Q,R,v,w);
    pint=isinter;
    pos=posicion2(P,Q,R);
    if pos==1
       if pint==0
           if intersec1(P,Q,v,w)==0
             plot([P(1),Q(1)],[P(2),Q(2)],'k')
             posi(k)=k+1;
           end
       end
    end 
end

clc;
picos=posi(posi~=0)
v(picos)=[];w(picos)=[];
n_inicial=n
n_final=n-numel(picos)