function [f1,f2,f3,f4,f5]=tdp0(th,s,t,flg)
% Subroutine for Pb. 2.7.8 & 8.5.8; TDP for max uf with soft TCs
% on (vf,yf), using FOP0N2; s=[u v y x]'; th=control;     7/3/02
%
yf=.2; sf=2e2; u=s(1); v=s(2); y=s(3); co=cos(th); si=sin(th); 
if flg==1
    f1=[co si v u]';
elseif flg==2
    f1=u-sf*(v^2+(y-yf)^2)/2; 
    f2=[1 -sf*v -sf*(y-yf) 0];
    f3=diag([0 -sf -sf 0]); 
elseif flg==3
    f1=[zeros(2,4); 0 1 0 0; 1 0 0 0];  
    f2=[-si co 0 0]';
    f3=zeros(16,4);
    f4=zeros(4);
    f5=[-co -si 0 0]';
end
	