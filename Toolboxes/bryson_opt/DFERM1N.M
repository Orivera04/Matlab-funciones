function [f1,f2,f3,f4,f5]=dferm1n(u,s,dt,t,flg)
% Subroutine for Pb. 8.4.4; max range with V=1+y using DOP0N2 with 
% quadratic penalty on y(N)-yf;   		                 4/97, 6/12/02
%
global yf sy; x=s(1); y=s(2); si=sin(u); c=cos(u); ta=tan(u);
a=exp(si*dt); 
if flg==1
   f1=[x+(1+y)*(a-1)/ta; a*(1+y)-1];	                        % f1=f
elseif flg==2
   f1=x-sy*(y-yf)^2/2; 
   f2=[1 -sy*(y-yf)];                                        % f2=phis
   f3=[0 0; 0 -sy];		                                    % f3=phiss
elseif flg==3
   f1=[1 (a-1)/ta; 0  a];                                      % f1=fs
   f2=(1+y)*[dt*c*a/ta-(a-1)/si^2; dt*c*a];                    % f2=fu
   f3=zeros(4,2);		         	                          % f3=fss
   f4=[0 dt*c*a/ta-(a-1)/si^2; 0 dt*c*a ];                    % f4=fus
   f5=(1+y)*[-dt*si*a/ta+dt^2*c^2*a^2/ta-...
     dt*c*a/si^2-dt*c*a/si^2+2*(a-1)*c/si^3;...
		-dt*si*a+dt^2*c^2*a^2];                               % f5=fuu
end
	
	        
	
	
