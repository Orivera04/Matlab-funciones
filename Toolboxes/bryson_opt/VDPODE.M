function sp=vdpode(t,s,flg,p)       
% Subroutine for Pb. 3.3.11; VDP for max range with gravity, thrust, and
% spec. yf; p=(Vf,gaf); V in g*tf, a in g, t in tf, (x,y) in  g*tf^2;
%                                                    11/96, 1/98, 6/19/98
%
global a; Vf=p(1); gaf=p(2); ga=s(3); si=sin(ga); c=cos(ga);
cf=cos(gaf); d=cf-a*sin(ga-gaf); V=Vf*c/d; 
sp=[V*si; V*c; d^2/(Vf*cf)];

