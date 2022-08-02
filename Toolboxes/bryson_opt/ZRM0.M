function [f1,f2]=zrm0(th,s,t,flg)		                                     
% Subroutine for Pbs. 2.4.2 & 2.6.2; max dist. in a linear current 
% uc=1+y; s=(x,y) in h, uc in V, t in h/V;         4/97, 8/21/97 
%
x=s(1); y=s(2); c=cos(th); si=sin(th);
if flg==1, f1=[c+y; si];
elseif flg==2, f1=x; f2=[1 0];
elseif flg==3, f1=[0 1; 0 0]; f2=[-si; c];
end


