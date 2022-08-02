function [f1,f2,f3]=vdpt(ga,s,t,flg)       
% Subroutine for p4_4_01; VDP for min time to a point with gravity;
% s=[V y x]'; V in sqrt(g*xf), t in sqrt(xf/g), (x,y) in xf;
%   			                                         12/96, 6/25/98
%
global yf; V=s(1); y=s(2); x=s(3); si=sin(ga); c=cos(ga);
if flg==1, f1=[si; V*si; V*c];
elseif flg==2, f1=[t; x-1; y-yf]; f2=[0 0 0; 0 0 1; 0 1 0];
   f3=[1 0 0]';
elseif flg==3, f1=[0 0 0; si 0 0; c 0 0]; f2=[c; V*c; -V*si];
end
