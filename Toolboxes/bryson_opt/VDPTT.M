function [f1,f2,f3]=vdptt(ga,s,t,flg)       
% Subroutine for p4_4_11; VDP for min time to a point with gravity &
% thrust; s=[V y x]'; a in g, V in g*tf, t in tf, (x,y) in  g*tf^2;
%                                                      2/97, 6/25/98
%
global xf yf a; V=s(1); y=s(2); x=s(3); si=sin(ga); c=cos(ga);
if flg==1, f1=[a+si; V*si; V*c];
elseif flg==2, f1=[t; y-yf; x-xf]; f2=[0 0 0; 0 1 0; 0 0 1]; 
   f3=[1 0 0]';
elseif flg==3, f1=[0 0 0; si 0 0; c 0 0]; f2=[c; V*c; -V*si];
end
