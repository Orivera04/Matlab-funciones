function isinter = interior1(P,R,Q,v,w)
%Programa para determinar si un pto.R es interior a un tri�ngulo PRQ.
%global n cont
n=numel(v);
for j=1:n-3
   S=[v(j+3),w(j+3)];cont=0;
   T=isalaizq(S,P,R)==0 & isalaizq(S,R,Q)==0 & isalaizq(S,Q,P)==0;
   %V=posicion2(P,Q,S)==2 & posicion2(Q,R,S)==2 & posicion2(R,P,S)==2
if T
    cont=1;
    isinter=1;
    return
else
    cont=0;
    
end
end
isinter=cont;
