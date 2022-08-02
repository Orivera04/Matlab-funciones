function [f1,f2,f3,f4,f5]=dtdptx(th,s,dt,t,flg)                   
% Subroutine for p4_2_07 & p4_5_07; DTDP for min tf to vf=0 and spec.
% (uf,yf,xf); t in units of uf/a; (u,v) in uf, (x,y) in uf^2/a;
% s=[u,v,y,x]'=state vector;  th=theta=control;          3/97, 6/25/98
%
uf=1; yf=.2/.4874^2; xf=.15/.4874^2; u=s(1); v=s(2); y=s(3); x=s(4);
co=cos(th); si=sin(th);
if flg==1, f1=s+dt*[co; si; v+dt*si/2; u+dt*co/2];
elseif flg==2, f1=[t; u-uf; v; y-yf; x-xf]; f2=[0 0 0 0; eye(4)];
   f3=[t/dt 0 0 0 0]';	                    
elseif flg==3, f1=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];                     
 f2=dt*[-si; co; dt*co/2; -dt*si/2]; f3=[co; si; v+dt*si; u+dt*co];
 f4=zeros(4);			   % f4 = fsu; f5 = fuu
 f5=dt*[-co; -si; -dt*si/2; -dt*co/2];
end

	
	
