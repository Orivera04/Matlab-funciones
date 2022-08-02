function [f1,f2,f3,f4]=dvdpc(u,s,dt,t,flg)                             
% Subroutine for Pbs. 3.2.1, 3.5.1, 8.4.1; DVDP for max range with
% gravity and specified yf; s=[v x y]'; u=gamma; t in units of tf, v in
% g*tf, a in g, (x,y) in g*(tf)^2;                         4/96, 6/8/98
%
yf=.1; v=s(1); x=s(2); y=s(3); c=cos(u); si=sin(u); dl=dt*(v+.5*si*dt);
if flg==1,
   f1=[v+si*dt; x+c*dl; y+si*dl];                                
elseif flg==2,
   f1=[x; y-yf]; 
   f2=[0 1 0; 0 0 1];                     
elseif flg==3,
   f1=[1 0 0; dt*c 1 0; dt*si 0 1];
   f2=dt*[c; -v*si+dt*(.5-si^2); v*c+dt*si*c];           
end

