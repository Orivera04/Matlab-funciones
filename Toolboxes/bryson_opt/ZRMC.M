function [f1,f2]=zrmc(th,s,t,flg)         
% Subroutine for p3_4_02; VDP for max range with uc=Vy/h 
% & spec. yf; s=[x y]' in units of h, t in units of h/V;
%                                         11/96, 7/16/02 
%
global yf; x=s(1); y=s(2); co=cos(th); si=sin(th);
if flg==1
    f1=[co+y; si];
elseif flg==2
    f1=[x; y-yf];
    f2=eye(2);
elseif flg==3
    f1=[0 1; 0 0];
    f2=[-si; co];
end

       
       