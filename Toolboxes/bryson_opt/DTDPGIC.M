function [f1,f2]=dtdpgic(th,s,dt,t,flg)                   
% Subroutine for p3_2_08 & p3_5_08; DTDP for max xf with  gravity & 
% spec. yf,u0,v0; t in tf; (u,v) in a*tf; (x,y) in a*tf^2/2, g in a;
% s=[u v x y]'; th = control;                          3/97, 6/13/92
%
global yf g; u=s(1); v=s(2); x=s(3); y=s(4); co=cos(th); si=sin(th);
if flg==1
    f1=s+dt*[co; si-g; u+dt*co/2; v+dt*(si-g)/2];
elseif flg==2
    f1=[x; y-yf]; 
    f2=[zeros(2) eye(2)];  
elseif flg==3
    f1=[1 0 0 0; 0 1 0 0; dt 0 1 0; 0 dt 0 1];                     
    f2=dt*[-si; co; -dt*si/2; dt*co/2];
end

	
