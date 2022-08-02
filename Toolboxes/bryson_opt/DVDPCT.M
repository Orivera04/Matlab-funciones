function [f1,f2,f3,f4]=dvdpct(u,s,dt,t,flg)                            
% Subroutine for Pb. 3.2.11, 3.5.11, 8.4.11; DVDP for max range with
% gravity, thrust, specified yf; s=[v x y]'; u=gamma; t in tf, v in 
% g*tf, a in g, (x,y) in g*(tf)^2; NOTE +ga, +y are UP;  4/97, 6/13/02
%
global a yf; v=s(1); x=s(2); y=s(3); co=cos(u); si=sin(u);
if flg==1
   f1=[v+(a-si)*dt; x+co*dt*(v+(a-si)*dt/2); y+si*dt*(v+(a-si)*dt/2)];
elseif flg==2
   f1=[x; y-yf]; 
   f2=[0 1 0; 0 0 1];
elseif flg==3
   f1=[1 0 0; dt*co 1 0; dt*si 0 1]; 
   f2=dt*[-co; -si*(v+(a-si)*dt/2)-co*co*dt/2; ...
           co*(v+(a-si)*dt/2)-co*si*dt/2];
   f3=[0 0 0; -dt*si 0 0; dt*co 0 0];  
   f4=dt*[si; -co*(v+(a-si)*dt/2)+si*co*dt/2+2*co*si*dt/2;...
	   -si*(v+(a-si)*dt/2)-co*si*dt/2-(co^2-si^2)*dt/2]; 
end


