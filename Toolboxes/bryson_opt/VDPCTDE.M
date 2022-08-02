function sp=vdpctde(t,s)       
% Subroutine for Pb. 3.6.12f,b; VDP for max range with gravity,
% thrust, drag, and specified yf; s=[V x y]'; (x,y) in l, V in
% sqrt(g*l), t in sqrt(l/g), a in g;	           5/97, 2/3/98
%
global a; V=s(1); lv=s(4); lx=s(5); ly=s(6); la=[lv lx ly]';
if V==0, ga=-pi/2; else ga=atan2(V*ly-lv,V*lx); end;
si=sin(ga); c=cos(ga); f=[a-si-V^2; V*c; V*si];
fs=[-2*V 0 0; c 0 0; si 0 0]; sp=[f;-fs'*la];

	
 
