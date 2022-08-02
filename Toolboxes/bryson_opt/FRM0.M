function [f1,f2]=frm0(u,s,t,flg)
% Subroutine for Pb. 2.4.4 & 2.6.4 - max range with V=1+y (Fermat Pb.);
%                                                  10/96, 8/97, 6/24/98
%
x=s(1); y=s(2); th=u; c=cos(th); si=sin(th);
if flg==1, f1=[(1+y)*c; (1+y)*si];
elseif flg==2, f1=x; f2=[1 0];
elseif flg==3, f1=[0 c; 0 si]; f2=[-(1+y)*si; (1+y)*c];
end   
		
	 
	   
	
	
