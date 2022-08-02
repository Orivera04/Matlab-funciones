function yp=calgldte(t,y)
% Subroutine for Pb. 4.6.16; max time constant-altitude glide (Ping Lu)
% with spec. (xf,yf,vf); s=[x y v ps]'; E=max L/D; om=2W/(rho*S*Vo^2*Cl1)
% where Cl1=Cl at max L/D; (x,y) in units of Vo^2/g, v in Vo, t in Vo/g;
% Vf=sqrt(om*Cl1/Clmax); Clmax=1.8*Cl1;               9/97, 2/98, 9/14/98
%
E=20; om=.23; v=y(3); ps=y(4); lx=y(5); ly=y(6); lv=y(7); lp=y(8);
la=[lx ly lv lp]'; u=atan2(E*v*lp,om*lv); cs=cos(ps); ss=sin(ps);
cu=cos(u); su=sin(u); 
f=[v*cs; v*ss; -(v^2+om^2/(v*cu)^2)/(2*E*om); su/(cu*v)];
fs=[zeros(2,4); cs ss -(v-om^2/(cu^2*v^3))/(E*om) ...
   -su/(cu*v^2); -v*ss v*cs 0 0]';
yp=[f; -fs'*la];   

   