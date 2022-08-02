function [f1,f2,f3,f4,f5]=dtdpt(th,s,dt,t,flg)                   
% Subroutine for e04_2_1, p4_2_06 & e04_5_1,2,3; DTDP for min tf to vf=0
% & spec. (uf,yf); t in units of  uf/a; (u,v) in uf; (x,y) in uf^2/a;
% s=[u v y x]'; th=control;                          3/97, 2/98, 6/25/98
%
uf=1; vf=0; yf=.2/.6716^2; u=s(1); v=s(2); y=s(3); co=cos(th); si=sin(th);
if flg==1, f1=s+dt*[co; si; v+dt*si/2; u+dt*co/2];
elseif flg==2, f1=[t; u-uf; v-vf; y-yf]; 
   f2=[0 0 0 0; eye(3) zeros(3,1)]; f3=[t/dt 0 0 0]';  			                   
elseif flg==3,                 
 f1=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];                         
 f2=dt*[-si; co; dt*co/2; -dt*si/2]; f3=[co; si; v+dt*si; u+dt*co];		            
 f4=zeros(4,4);				                                 % f4=fus
 f5=dt*[-co; -si; -dt*si/2; -dt*co/2];                      % f5=fuu
end

	
