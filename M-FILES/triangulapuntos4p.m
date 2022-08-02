function triangulapuntos4h(v,w)
%Función para triangular polígonos.
global picos h n_inicial n_final;
n=numel(v);
hold on;
posi=0;
for k=h:n-3
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    isinter=interior3(P,Q,R,h,v,w);
    pint=isinter;
    pos=posicion2(P,Q,R);
    if pos==1
       if pint==0
          plot([P(1),Q(1)],[P(2),Q(2)],'k')
          posi(k)=k+1;
       end
    end 
end

clc;
picos=posi(posi~=0)
v(picos)=[];w(picos)=[];
n_inicial=n
n_final=n-numel(picos)