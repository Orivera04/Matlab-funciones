function sp=vdptdode(t,s,flg,p)       
% Subroutine for Pb. 3.3.12; VDP for max range with gravity, thrust,
% drag, & specified yf; p=(Vf,gaf); s=[V y x ga]';            7/2/98
%
global a; Vf=p(1); gaf=p(2); V=s(1); y=s(2); x=s(3); ga=s(4);
si=sin(ga); c=cos(ga); cf=cos(gaf); 
%vsg=(Vf/cf-V*(a-V^2)*tan(gaf))/(1-(a-V^2)*si); 
sp=[a-si-V^2; V*si; V*c; 2*V*c*sin(ga-gaf)/cf+Vf*c^2/(cf*V^2)];

