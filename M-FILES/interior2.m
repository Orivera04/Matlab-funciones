function isinter=interior2(P,R,Q,v,w);
%Verifica si el pto. P es interior al triángulo P1P2P3 o no.
conta=0;n=numel(v);
for j=1:n-3
   P=[v(j),w(j)];R=[v(j+1),w(j+1)];Q=[v(j+2),w(j+2)];S=[v(j+3),w(j+3)];
   x1=P(1);y1=P(2);x2=R(1);y2=R(2);x3=Q(1);y3=Q(2);x=S(1);y=S(2);
   Area_SPR= 1/2. *abs(det([x y 1;x1 y1 1;x2 y2 1]));
   Area_SRQ= 1/2. *abs(det([x y 1;x2 y2 1;x3 y3 1]));
   Area_SQR= 1/2. *abs(det([x y 1;x3 y3 1;x1 y1 1]));
   Area_PQR= 1/2. *abs(det([x1 y1 1;x2 y2 1;x3 y3 1]));
   Sum=(Area_SPR + Area_SRQ + Area_SQR);
   compareas=isequal(Sum, Area_PQR);  
   if compareas==1
       conta=1;
       break
   end
end
isinter=conta;

