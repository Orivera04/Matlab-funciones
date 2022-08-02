function [f1,f2,f3]=calgldt(sg,s,t,flg)
% Subroutine for p4_4_16 & p4_6_16; max time const.-altitude glide 
% (P. Lu) w. spec. (xf,yf,vf); s=[x y v ps]'; u=sg;  E=max L/D;
% om=2W/(rho*S*Vo^2*Cl1) where Cl1=Cl at max L/D; (x,y) in units of
% Vo^2/g, v in Vo, t in Vo/g; Vf=sqrt(om*Cl1/Clmax); Clmax=1.8*Cl1;
%                                                         9/97, 2/5/98
%
E=20; om=.23; x=s(1); y=s(2); v=s(3); ps=s(4); cs=cos(ps); ss=sin(ps);
cu=cos(sg); su=sin(sg);
if flg==1, f1=[v*cs; v*ss; -(v^2+om^2/(v*cu)^2)/(2*E*om); su/(cu*v)];
elseif flg==2, f1=[t; x; y; v-.3575]; f2=[0 0 0 0; 1 0 0 0; ...
     0 1 0 0; 0 0 1 0]; f3=[1 0 0 0]';
elseif flg==3, f1=[zeros(2,4); cs ss -(v-om^2/(cu^2*v^3))/(E*om) ...
     -su/(cu*v^2); -v*ss v*cs 0 0]'; f2=[0 0 -om*su/(E*v^2*cu^3) ...
     1/(cu^2*v)]'; 
end

