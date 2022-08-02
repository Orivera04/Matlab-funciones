function [f1,f2,f3,f4,f5]=dvdpctn(u,s,dt,t,flg)                            
% Subroutine for Pb. 8.4.5; DVDP for max range w. gravity, thrust, and
% quad. penalty on y(tf)-yf; s=[v x y]'; u=gamma; t in tf, v in g*tf,
% a in g, (x,y) in g*(tf)^2; NOTE +ga, +y are UP;  		 4/97, 6/13/02
%
global a yf sy; v=s(1); x=s(2); y=s(3); c=cos(u); si=sin(u);
if flg==1,
 f1=[v+(a-si)*dt; x+c*dt*(v+(a-si)*dt/2); ...
     y+si*dt*(v+(a-si)*dt/2)];                                % f1 = f
elseif flg==2,
 f1=x+sy*(y-yf)^2;                                          % f1 = phi
 f2=[0 1 sy*(y-yf)];                                       % f2 = phis
 f3=[0 0 0; 0 0 0; 0 0 sy];		                          % f3 = phiss
elseif flg==3,
 f1=[1 0 0; dt*c 1 0; dt*si 0 1];                            % f1 = fs
 f2=dt*[-c; -si*(v+(a-si)*dt/2)-c*c*dt/2; ...                % f2 = fu
              c*(v+(a-si)*dt/2)-c*si*dt/2];
 f3=zeros(9,3);				                                % f3 = fss
 f4=[0 0 0; -dt*si 0 0; dt*c 0 0];                          % f4 = fus 
 f5=dt*[si; -c*(v+(a-si)*dt/2)+si*c*dt/2+2*c*si*dt/2;...
	   -si*(v+(a-si)*dt/2)-c*c*dt/2-(c^2-si^2)*dt/2];       % f5 = fuu
end


	
