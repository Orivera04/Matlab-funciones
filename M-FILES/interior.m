function isinter = interior(P,R,Q,S,v,w)
%Programa para determinar si un pto. es interior a un triángulo.

n=numel(v);
for j=1:n-4
   S=[v(j+3),w(j+3)];
   T=posicion2(P,R,S)==1 & posicion2(R,Q,S)==1 & posicion2(Q,P,S)==1
   V=posicion2(P,Q,S)==2 & posicion2(Q,R,S)==2 & posicion2(R,P,S)==2
if T|V
    PI(j)=1;
    else 
    PI(j)=0;
end
clc;
end 
   if any(PI)==1
       isinter=1
   else
       isinter=0
   end
   PI;
end
