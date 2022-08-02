function sp=dip_mf(t,s)
% File for p9_3_04e, min fuel DIP w. bdd. ctrl.
%
x=s(1); v=s(2);
if v>=0, u=-1; end
if v<0 & t>=1+v/2+x/v, u=-1; end  
if v<0 & t<=1+v/2+x/v, u=0; end  
if v<0 & 2*x-v^2<0, u=1; end
sp=[v u]';