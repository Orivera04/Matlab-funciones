function [f1,f2,f3,f4,f5]=vdpt0y(u,s,t,flg)                      
% Subroutine for Pb. 2.7.5 & 8.7.5; VDP for max range w. gravity
% and thrust & spec. yf; s=[v x y]'; t in units of sqrt(l/g), v 
% in sqrt(g*l), x in l;                                   7/3/02
%
global a yf sy
V=s(1); x=s(2); y=s(3); ga=u; co=cos(ga); si=sin(ga); 
if flg==1
    f1=[a+si; V*co; V*si];       
elseif flg==2
    f1=x-sy*(y-yf)^2/2;
    f2=[0 1 -sy*(y-yf)];
    f3=[0 0 0; 0 0 0; 0 0 -sy];
elseif flg==3
    f1=[0 0 0; co 0 0; si 0 0]; 
    f2=[co; -V*si; V*co];
    f3=zeros(9,3);
    f4=[0 0 0; -si 0 0; 0 0 co];
    f5=[-si; -V*co; -V*si];
end

