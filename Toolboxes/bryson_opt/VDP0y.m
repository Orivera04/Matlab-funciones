function [f1,f2,f3,f4,f5]=vdp0y(u,s,t,flg)                      
% Subroutine for Pb. 2.7.1 & 8.5.1; 7/7/02
%
global yf sy; V=s(1); x=s(2); y=s(3);
ga=u; co=cos(ga); si=sin(ga);
if flg==1
    f1=[si; V*co; V*si];
elseif flg==2
    f1=x-sy*(y-yf)^2/2; 
    f2=[0 1 -sy*(y-yf)];
    f3=[0 0 0; 0 0 0; 0 0 -sy];
elseif flg==3
    f1=[0 0 0; co 0 0; si 0 0];
    f2=[co -V*si V*co]';
    f3=zeros(9,3);
    f4=[0 0 0; -si 0 0; co 0 0];
    f5=[-si -V*co -V*si]';
end   