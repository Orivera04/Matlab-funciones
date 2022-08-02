function [f1,f2]=vdpct(ga,s,t,flg)       
% Subroutine for Pbs. 3.4.11, 3.6.11; VDP for max xf w. gravity, thrust,
% and specified yf; s=[V y x]'; a in g, V in g*tf, t in tf, (x,y) in
% g*tf^2;	                                         2/97, 2/98, 6/23/98
%
global a yf; V=s(1); y=s(2); x=s(3); si=sin(ga); c=cos(ga);
if flg==1, f1=[a-si; V*si; V*c];
elseif flg==2, f1=[x; y-yf]; f2=[0 0 1; 0 1 0];
elseif flg==3, f1=[0 0 0; si 0 0; c 0 0]; f2=[-c; V*c; -V*si];
end
