function [f1,f2,f3]=vdpgtdt(ga,s,t,flg)                      
% Subroutine for p4_4_12 & p4_6_12n; VDP for min time to spec. range
% w. gravity, thrust, & drag; s=[V x y]'; t in units of sqrt(l/g), V 
% in sqrt(g*l), x in l, a in g;             1/93, 8/97, 6/98, 9/13/98
%
global yf xf a; V=s(1); x=s(2); y=s(3); c=cos(ga); si=sin(ga);
if flg==1, f1=[a-si-V^2; V*c; V*si];  		                  
elseif flg==2, f1=[t; x-xf; y-yf]; f2=[0 0 0; 0 1 0; 0 0 1];
   f3=[1 0 0]';                                   
elseif flg==3, f1=[-2*V 0 0; c 0 0; si 0 0]; f2=[-c; -V*si; V*c]; end

