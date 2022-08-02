function isinter = interior3(P,Q,R,v,w)
%Programa para determinar si un pto. es interior a un triángulo.
global isinter
n=numel(v);
for j=1:n-3
   S=[v(j+3),w(j+3)];MatPun=[P(1),P(2);Q(1),Q(2);R(1),R(2)];
   AB=[P(1),P(2),Q(1),Q(2)];CD=[R(1),R(2),Q(1),Q(2)];
   min_xy=min(MatPun);max_xy=max(MatPun);
   xmin=min(min_xy(1));xmax=max(max_xy(1));ymin=min(min_xy(2));ymax=max(max_xy(2));
   cont=0;
   M=isalaizq2(S,AB);
   N=isalaizq2(S,CD);
   T=M==1 & N==0; 
   V=(S(1)>xmin&S(1)<xmax)&((S(2)>ymin&S(2)<ymax));
if T&V
    cont=1;
    break
end
%clc;
end 
isinter=cont
  

