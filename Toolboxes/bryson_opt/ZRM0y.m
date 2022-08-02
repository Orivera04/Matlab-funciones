function [f1,f2]=zrm0y(th,s,t,flg)		                                     
% Subroutine for Pb. 2.4.10;   6/25/02 
%
global sy yf
x=s(1); y=s(2); co=cos(th); si=sin(th);
if flg==1
    f1=[co+y; si];
elseif flg==2
    f1=x-sy*(y-yf)^2/2;
    f2=[1 -sy*(y-yf)];
elseif flg==3
    f1=[0 1; 0 0]; 
    f2=[-si; co];
end


