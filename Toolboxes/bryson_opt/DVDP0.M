function [f1,f2]=dvdp0(u,s,dt,t,flg)            
% Subroutine for Examples 2.2.1 & 2.5.1 & Pb. 2.2.1;
% DVDP for max range; s=[v x]'; u=gamma; t in units
% of tf, v in g*tf, x in g*tf^2;       4/94, 7/22/02
%
v=s(1); x=s(2); si=sin(u); co=cos(u);
if flg==1
   f1=s+dt*[si; v*co+dt*si*co/2];
elseif flg==2
   f1=x;
   f2=[0 1];
elseif flg==3
   f1=eye(2)+dt*[0 0; co 0]; 
   f2=dt*[co; -v*si+dt*(co^2-si^2)/2]; 
end

