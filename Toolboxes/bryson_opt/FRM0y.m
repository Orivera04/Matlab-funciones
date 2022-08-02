function [f1,f2,f3,f4,f5]=frm0y(u,s,t,flg)
% Subroutine for Pb. 2.7.4 & 8.5.4 - max range with V=1+y 
% (Fermat Pb.) w. soft penalty on y-yf;     10/96, 7/3/02
%
global yf sy
x=s(1); y=s(2); th=u; co=cos(th); si=sin(th);
if flg==1
    f1=[(1+y)*co; (1+y)*si];
elseif flg==2
    f1=x-sy*(y-yf)^2/2;
    f2=[1 -sy*(y-yf)];
    f3=[0 0; 0 -sy];
elseif flg==3
    f1=[0 co; 0 si];
    f2=(1+y)*[-si; co];
    f3=zeros(4,2);
    f4=[0 -si; 0 co];
    f5=(1+y)*[-co; -si];
end   
		
	 
	   
	
	
