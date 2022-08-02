function [f1,f2]=dferm1(u,s,dt,t,flg)
% Subroutine for Pbs. 2.2.4 & 2.5.4; max range with V=1+y (Fermat Pb.);
% u=th;			                                    10/96, 3/97, 6/23/98
%
x=s(1); y=s(2); si=sin(u); c=cos(u); ta=tan(u); a=exp(dt*si); 
if flg==1, f1=[x+(1+y)*(a-1)/ta; a*(1+y)-1];
elseif flg==2, f1=x; f2=[1 0];
elseif flg==3, f1=[1 (a-1)/ta; 0  a];
	 f2=(1+y)*[dt*c*a/ta-(a-1)/si^2; dt*c*a];
end
	
	        
	
	
