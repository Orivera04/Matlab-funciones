function [f1,f2,f3,f4,f5]=dvdp0n(u,s,dt,t,flg)                             
% Subroutine for Pb. 8.4.01; DVDP for max range with gravity & quadratic
% penalty on y(N)-yf; s=[v x y]'; u=gamma; t in units of tf, v in g*tf,
% (x,y) in g*(tf)^2;		                               4/97, 6/11/02
%				          
global yf sy; v=s(1); x=s(2); y=s(3); co=cos(u); si=sin(u);
dl=dt*(v+.5*si*dt);
if flg==1
 f1=[v+si*dt; x+co*dl; y+si*dl];                                % f1 = f
elseif flg==2
 f1=x-sy*(y-yf)^2/2; 
 f2=[0 1 -sy*(y-yf)];                                        % f2 = phis
 f3=[0 0 0; 0 0 0; 0 0 -sy];                                % f3 = phiss
elseif flg==3
 f1=[1 0 0; dt*co 1 0; dt*si 0 1];                             % f1 = fs
 f2=dt*[co; -v*si+dt*(.5-si^2); v*co+dt*si*co];                % f2 = fu
 f3=zeros(9,3);				                                  % f3 = fss
 f4=[0 0 0; -dt*si 0 0; dt*co 0 0];                           % f4 = fsu
 f5=dt*[-si; -v*co-dt*2*si*co; -v*si+dt*(co^2-si^2)];         % f5 = fuu
end

