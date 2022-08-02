function [f1,f2]=noshp(u,s,t,flg)      
% Subroutine for e02_4_1; min drag nose shape using FOP0; t-->x;
% s=[d r]'; u=-tan(theta); lengths in a=r(0); drag in q*pi*a^2 where
% q=dynamic pressure;                            9/96, 8/97, 6/27/98
% 
d=s(1); r=s(2);
if flg==1, f1=[4*r*u^3/(1+u^2); -u];
elseif flg==2, f1=2*r^2+d; f2=[1 4*r];
elseif flg==3, f1=zeros(2,2); f1(1,2)=4*u^3/(1+u^2);
    f2=[4*r*u^2*(3+u^2)/(1+u^2)^2; -1];
end

