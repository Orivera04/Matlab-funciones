function [f1,f2,f3]=zrmt(th,s,t,flg)         
% Subroutine for p4_5_02; VDP for max range with uc=Vy/h & spec. yf;
% s=[x y]' in units of h, t in units of h/V; 		  11/96, 9/10/02 
%
global xf yf; x=s(1); y=s(2); co=cos(th); si=sin(th);
if flg==1
    f1=[co+y; si];
elseif flg==2
    f1=[t; x-xf; y-yf];
    f2=[0 0; eye(2)]; 
    f3=[1 0 0]';
elseif flg==3
    f1=[0 1; 0 0]; 
    f2=[-si; co];
end

       
       