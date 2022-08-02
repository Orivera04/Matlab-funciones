function [f1,f2]=dvdpt0(u,s,dt,t,flg)            
% Subroutine for Pb. 2.2.5 and 2.5.5; DVDP for max range w. gravity & thrust;
% s=[v x y]'; u=gamma; t in units of tf, v in g*tf, (x,y) in g*tf^2, a in g;
% 	                                                             4/97, 6/8/98
global a; v=s(1); x=s(2); y=s(3); si=sin(u); c=cos(u);
if flg==1, f1=s+dt*[a+si; v*c+dt*(a+si)*c/2; v*si+dt*(a+si)*si/2];            
elseif flg==2, f1=x; f2=[0 1 0];                            
elseif flg==3,
 f1=eye(3)+dt*[0 0 0; c 0 0; si 0 0];     
 f2=dt*[c; -v*si+dt*(-a*si+c^2-si^2)/2; v*c+ dt*(a*c+2*si*c)/2];      
end

