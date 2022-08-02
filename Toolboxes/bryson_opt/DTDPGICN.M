function [f1,f2,f3,f4,f5]=dtdpgicn(th,s,dt,t,flg)                   
% Subroutine for Pb. 8.4.8; DTDP for max xf w. gravity & spec.
% yf, u0, v0; t in tf; (u,v) in a*tf; (x,y) in a*tf^2, g in a; 
% s=[u v x y]'; th=control;                      4/97, 6/13/02
%
global g yf sf; 
u=s(1); v=s(2); x=s(3); y=s(4); co=cos(th); si=sin(th);
if flg==1
     f1=s+dt*[co; si-g; u+dt*co/2; v+dt*(si-g)/2];
elseif flg==2
     f1=[x-sf*(y-yf)^2/2]; 
     f2=[0 0 1 -sf*(y-yf)];
     f3=[zeros(3,4); 0 0 0 -sf];  
elseif flg==3
     f1=[1 0 0 0; 0 1 0 0; dt 0 1 0; 0 dt 0 1];                     
     f2=dt*[-si; co; -dt*si/2; dt*co/2];            
     f3=zeros(16,4); 
     f4=zeros(4); 
     f5=dt*[-co; -si; -dt*co/2; -dt*si/2];
end

	
