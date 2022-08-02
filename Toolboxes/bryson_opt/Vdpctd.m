function [f1,f2]=vdpctd(ga,s,t,flg)                      
% Subroutine for Pb. 3.4.12 & 3.6.12n; VDP for max range w. gravity, thrust,
% & drag; s=[v x y]'; t in units of sqrt(l/g), v in sqrt(g*l), x in l, a in g;  
% 				                             1/93, 5/97, 2/98, 6/14/98
%
global a yf; V=s(1); x=s(2); y=s(3); c=cos(ga); si=sin(ga);
if flg==1, f1=[a-si-V^2; V*c; V*si];  		    
elseif flg==2, f1=[x; y-yf]; f2=[0 1 0; 0 0 1];
elseif flg==3, f1=[-2*V 0 0; c 0 0; si 0 0]; f2=[-c; -V*si; V*c];
end

