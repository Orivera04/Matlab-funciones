function [f1,f2,f3,f4]=dzrmc(th,s,dt,t,flg)         
% Subroutine for Pbs. 3.2.2 & 3.5.2; DVDP for max range w. uc=Vy/h, 
% y(N)=yf; s=[x y]' in units of h, t in h/V;           4/97, 6/9/02 
%
yf=0; x=s(1); y=s(2); si=sin(th); co=cos(th);
if flg==1
    f1=s+dt*[co+y+.5*dt*si; si];
elseif flg==2
    f1=[x; y-yf];
    f2=eye(2);
elseif flg==3
    f1=[1 dt; 0 1]; 
    f2=dt*[-si+.5*dt*co; co];
    f3=zeros(2);
	f4=dt*[-co-.5*dt*si; -si];
end

       
       