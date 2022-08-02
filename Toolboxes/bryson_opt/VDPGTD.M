function yp=vdpgtd(t,s,flag,a)	
% Subroutine for Pb. 2.3.6; VDP for max range with gravity, thrust, 
% and drag;	                                                 2/8/98
%
V=s(1); ga=s(2); si=sin(ga); co=cos(ga);
yp=[a-V^2-si co*(1-(a-3*V^2)*si)/V  V*co V*si]';
	
	