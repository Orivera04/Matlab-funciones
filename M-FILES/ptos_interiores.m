function isinter=interior(A,B,C,P)
%Programa para determinar si un pto. es interior a un tri�ngulo.
T=(posicion2(A,B,P)==1)&(posicion2(B,C,P==1)&(posicion2(,B,CP==1);
V=(posicion2(A,B,P)==2)&(posicion2(B,C,P==2)&(posicion2(B,C,P==2);
if T|V
    isinter=1                  
else
    isinter =0
end