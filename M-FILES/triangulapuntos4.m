function triangulapuntos4(v,w)
%Función para triangular polígonos.
global x y picos  n_inicial n_final;
n=numel(v);
posi=0;cruces=0;hold on;
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
          plot([P(1),Q(1)],[P(2),Q(2)],'k')
          posi(k)=k+1;
       end
    end 
end
picos=posi(posi~=0);v(picos)=[];w(picos)=[];n_inicial=n;n_final=n-numel(picos);





    
    



