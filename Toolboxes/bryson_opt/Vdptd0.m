function [f1,f2]=vdptd0(u,s,t,flg)                      
% Subroutine for Pb. 2.4.6 & 2.6.6n; VDP for max range with
% gravity, thrust, & drag;                         1/93, 7/2/02
%
global a; V=s(1); x=s(2); y=s(3); ga=u; co=cos(ga); si=sin(ga);
if flg==1
    f1=[a+si-V^2; V*co; V*si];
elseif flg==2
    f1=x; 
    f2=[0 1 0];
elseif flg==3
    f1=[-2*V 0 0; co 0 0; si 0 0];
    f2=[co; -V*si; V*co];      		   
end
