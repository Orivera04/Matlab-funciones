function [f1,f2,f3]=zrmpt(th,s,t,flg)		                                     
% Subroutine for p4_4_14; min time in parabolic current uc=1-y^2; 
% s=(x,y) in h, uc in V, t in h/V;               2/97, 6/98, 9/13/98 
%
global xf yf; x=s(1); y=s(2); c=cos(th); s=sin(th);
if flg==1, f1=[-c+1-y^2; s];
elseif flg==2, f1=[t; x-xf; y-yf]; f2=[0 0; 1 0; 0 1]; f3=[1; 0; 0];
elseif flg==3, f1=[0 -2*y; 0 0]; f2=[s; c];
end


