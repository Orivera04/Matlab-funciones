function [f1,f2]=dtdpic(th,s,dt,t,flg)                   
% Subroutine for Pb. 3.2.5 and 3.5.5; DTDP for max xf to yf=0; t in units
% of tf; (u,v) in a*tf; (x,y) in a*tf^2; s=[u,v,x,y]'; th=control;
%		                                                      2/97, 6/10/98
u=s(1); v=s(2); x=s(3); y=s(4); co=cos(th); si=sin(th);
if flg==1, f1=s+dt*[co; si; u+dt*co/2; v+dt*si/2];
elseif flg==2, f1=[x; y]; f2=[zeros(2) eye(2)];  
elseif flg==3, f1=[1 0 0 0; 0 1 0 0; dt 0 1 0; 0 dt 0 1];                     
    f2=dt*[-si; co; -dt*si/2; dt*co/2];
end

	
