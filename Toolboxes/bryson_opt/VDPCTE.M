function sp=vdpcte(t,s)	
% Subroutine for p3_6_11f,b; VDP for max range with gravity, thrust & yf
% specified; shooting solution; s=[V y x]';		    11/96, 2/98, 6/23/98
%
global a; V=s(1); y=s(2); x=s(3); lv=s(4); ly=s(5); lx=s(6);
if V==0, ga=-pi/2; else ga=atan((ly-lv/V)/lx); end;
c=cos(ga); si=sin(ga); sp=[a-si V*si V*c -lx*c-ly*si 0 0]';
	
	