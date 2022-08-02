function [f1,f2,f3,f4,f5]=dzrm0n(u,s,dt,t,flg)                   
% Subroutine for Pb. 8.4.02;                          4/97, 6/25/02
%
x=s(1); y=s(2); co=cos(u); si=sin(u); yf=0; sf=2e2; 
if flg==1
  f1=s+dt*[co+y+dt*si/2; si];                           % f1=dot(s)	               
elseif flg==2
  f1=x-sf*(y-yf)^2/2;                                      % f1=phi
  f2=[1 -sf*(y-yf)];		                              % f2=phis             
  f3=[0 0; 0 -sf];			                             % f3=phiss  
elseif flg==3
  f1=[1 dt; 0 1];                                           % f1=fs
  f2=dt*[-si+dt*co/2; co];		                            % f2=fu
  f3=zeros(4,2);	    		                           % f3=fss  
  f4=zeros(2);				                               % f4=fus
  f5=dt*[-co-dt*si/2; -si];		                           % f5=fuu
end