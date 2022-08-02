function [f1,f2]=vdp0(u,s,t,flg)                      
% Subroutine for Pbs. 2.2.1, 2.4.1, 2.6.1; VDP for max range w. gravity; 
% s=[v x y]'; 		 	                                1/93, 8/97, 6/24/98
%
V=s(1); x=s(2); ga=u; c=cos(ga); si=sin(ga);
if flg==1, f1=[si; V*c; V*si];
elseif flg==2, f1=x; f2=[0 1 0];
elseif flg==3, f1=[0 0 0; c 0 0; si 0 0]; f2=[c; -V*si; V*c];
end   