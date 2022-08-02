function f=noshp_f(u,tf)                            
% Subroutine for e02_4_2; min drag nose shape; t-->x=distance;
% s=[d r]'; u=-tan(theta); lengths in a=r(0); drag in q*pi*a^2
% where q=dynamic pressure;                     11/94, 8/15/02
%
s0=[0 1]'; N=length(u); [t,s]=odeu('noshp',u,s0,tf); 
f=2*s(2,N)^2+s(1,N);


