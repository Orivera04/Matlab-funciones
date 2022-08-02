function [f1,f2]=vdpt0(u,s,t,flg)                      
% Subroutine for Pb. 2.4.5 & 2.6.5; VDP for max range w. gravity and
% thrust; s=[v x y]'; t in units of sqrt(l/g), v in sqrt(g*l), x in l;
%                                                 10/96, 8/97, 6/24/98
%
a=1; V=s(1); x=s(2); y=s(3); ga=u; c=cos(ga); si=sin(ga); 
if flg==1, f1=[a+si; V*c; V*si];       
elseif flg==2, f1=x; f2=[0 1 0];
elseif flg==3, f1=[0 0 0; c 0 0; si 0 0]; f2=[c; -V*si; V*c];       
end

