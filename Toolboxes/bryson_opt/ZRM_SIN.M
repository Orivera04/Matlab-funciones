function [f1,f2]=zrm_sin(th,s,t,flg)                                     
% Subroutine for Pb. 8.7.3; Zermelo Pb. with sinusoidal current; 
% s=[x y]';			            	                               7/23/98
%
x=s(1); y=s(2);
if flg==1,
   f1=[cos(th)+(sin(y))^2; sin(th)];
elseif flg==2,
   f1=[x; y]; f2=eye(2);
elseif flg==3,
   f1=[0 0; 0 sin(2*y)]; f2=[-sin(th); cos(th)];   
end;

