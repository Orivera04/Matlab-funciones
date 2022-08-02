function [f1,f2,f3,f4,f5]=dtdpgcxn(th,s,dt,t,flg)                          
% Subroutine for Pbs. 8.4.10; DTDP for max uf w. gravity and (vf,yf,xf)
% specified; s=[u v y x]', th=control; t in tf, g in a, (u,v) in a*tf,
% (x,y) in a*tf^2;		                                  4/97, 7/4/98 
%
global yf xf g sf; u=s(1); v=s(2); y=s(3); x=s(4); co=cos(th);
si=sin(th);
if flg==1, f1=s+dt*[co; si-g; v+dt*(si-g)/2; u+dt*co/2];
elseif flg==2, f1=[u-sf*(v^2+(y-yf)^2+(x-xf)^2)/2];
 f2=[1 -sf*v -sf*(y-yf) -sf*(x-xf)];
 f3=[0 0 0 0; 0 -sf 0 0; 0 0 -sf 0; 0 0 0 -sf]; 
elseif flg==3, f1=eye(4)+dt*[zeros(2,4); 0 1 0 0; 1 0 0 0];                     
 f2=dt*[-si; co; dt*co/2; -dt*si/2]; f3=zeros(16,4);
 f4=zeros(4); f5=dt*[-co; -si; -dt*si/2; -dt*co/2];   
end

