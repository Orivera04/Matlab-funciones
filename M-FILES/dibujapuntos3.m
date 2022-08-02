function dibujapuntos3(v,w)
%poliplot(v,w);
global posi 
n=numel(v)
hold on;
for k=1:2:n-2 % k=1:2:n-2
    P=[v(k),w(k)];
    Q=[v(k+2),w(k+2)];
    R=[v(k+1),w(k+1)];
    pos=posicion2(P,Q,R);
    if pos==1
    plot([P(1),Q(1)],[P(2),Q(2)],'k')
    %v(k+1)=[];w(k+1)=[];
    posi(k)=k+1;
    end 
end
posi
