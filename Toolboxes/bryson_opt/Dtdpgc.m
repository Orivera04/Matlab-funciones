function [f1,f2,f3,f4]=dtdpgc(th,s,dt,t,flg)                          
% Subroutine for Pbs. 3.2.9, 3.5.9; DTDP for max uf w. gravity & 
% (vf,yf) specified;  s=[u,v,y,x]', th=control; t in units of tf,
% g in a, (u,v) in a*tf, (x,y) in a*tf^2;                 3/31/97 
%
g=1/3; yf=.2; u=s(1); v=s(2); y=s(3); x=s(4); co=cos(th);
si=sin(th);
if flg==1,                                             % f1 = f
 f1=s+dt*[co; si-g; v+dt*(si-g)/2; u+dt*co/2];
elseif flg==2, 		                     % f1 = Phi, f2 = Phis
 f1=[u; v; y-yf];  f2=[eye(3) zeros(3,1)]; 
elseif flg==3,                               % f1 = fs; f2 = fu
 f1=eye(4)+dt*[zeros(2,4); 0 1 0 0; 1 0 0 0];                     
 f2=dt*[-si; co; dt*co/2; -dt*si/2];  f3=zeros(4);
 f4=dt*[-co; -si; -dt*si/2; -dt*co/2];  
end

