function [f1,f2]=vdpc(ga,s,t,flg)       
% Subroutine for Pbs. 3.4.01 & 3.6.01n; VDP for max range w. gravity
% & specified yf; s=[V y x]'; V in g*tf, t in tf, (x,y) in  g*tf^2;
%                                                     11/96, 7/16/02
%
global yf; V=s(1); y=s(2); x=s(3); si=sin(ga); co=cos(ga);
if flg==1
    f1=[si; V*si; V*co];
elseif flg==2
    f1=[x; y-yf];
    f2=[0 0 1; 0 1 0];
elseif flg==3
    f1=[0 0 0; si 0 0; co 0 0];
    f2=[co; V*co; -V*si];
end
