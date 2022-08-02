function triangula5a(v,w)
%Programa para triangular un pol�gono de 5 lados
clc;
P=[v(1),w(1)];
R=[v(2),w(2)];
Q=[v(3),w(3)];
S=[v(4),w(4)];
 T1=posicion2(P,R,S)==2 & posicion2(R,Q,S)==2 & posicion2(Q,P,S)==2;
 T2=posicion2(R,Q,P)==2 & posicion2(Q,S,P)==2 & posicion2(S,R,P)==2;
 T3=posicion2(Q,S,R)==2 & posicion2(S,P,R)==2 & posicion2(P,Q,R)==2;
 T4=posicion2(S,P,Q)==2 & posicion2(P,R,Q)==2 & posicion2(R,S,Q)==2;
 %V=posicion2(P,Q,S)==2 & posicion2(Q,R,S)==2 & posicion2(R,P,S)==2

if T1
     plot([v(2),v(4)],[w(2),w(4)],'r')
elseif T2
     plot([v(1),v(3)],[w(1),w(3)],'k')
elseif T3 
     plot([v(2),v(4)],[w(2),w(4)],'m')
elseif T4
     plot([v(1),v(3)],[w(1),w(3)],'c')
else
     plot([v(1),v(3)],[w(1),w(3)],'b') 
end
