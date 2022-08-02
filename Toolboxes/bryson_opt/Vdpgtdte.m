function yp=vdpgtdte(t,y)                      
% Subroutine for p4_6_12f,b; fwd. EL eqns. for VDP for min time to (xf,yf)
% with gravity, thrust, & drag; s=[v x y]'; t in units of sqrt(l/g), v 
% in sqrt(g*l),(x,y) in l, a in g;					       6/97, 6/98, 9/14/98
%
global a; v=y(1); lv=y(4); lx=y(5); ly=y(6); la=[lv lx ly]';
if v==0, ga=-pi/2; else ga=atan2(-v*ly+lv,-v*lx); end; c=cos(ga);
si=sin(ga); f=[a-si-v^2; v*c; v*si]; fs=[-2*v 0 0; c 0 0; si 0 0];              
yp=[f; -fs'*la];

 