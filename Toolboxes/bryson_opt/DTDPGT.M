function [f1,f2,f3,f4,f5]=dtdpgt(th,s,dt,t,flg)                          
% Subroutine for p4_2_09 & p4_5_09; DTDP w. gravity to vf=0, spec. 
% (uf,yf); s=[u,v,y,x]'; th=control; t in units of uf/a, g in a, (u,v)
% in uf, (x,y) in uf^2/a; 				                      3/97, 6/25/98
%
global yf g; u=s(1); v=s(2); y=s(3); x=s(4); co=cos(th); si=sin(th);
if flg==1, f1=s+dt*[co; si-g; v+dt*(si-g)/2; u+dt*co/2];
elseif flg==2, f1=[t; u-1; v; y-yf];
 f2=[0 0 0 0; 1 0 0 0; 0 1 0 0; 0 0 1 0]; f3=[t/dt 0 0 0]'; 		            
elseif flg==3, f1=eye(4)+dt*[0 0 0 0; 0 0 0 0; 0 1 0 0; 1 0 0 0];                     
   f2=dt*[-si; co; dt*co/2; -dt*si/2];
   f3=[co; si-g; v+dt*(si-g); u+dt*co];
   f4=zeros(4);			                                  % f4 = fus
   f5=dt*[-co; -si; -dt*si/2; -dt*co/2];               % f5 = fuu
end

