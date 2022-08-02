function sp=frm0ys(t,s)
% Subroutine for Pb. 8.5.4;           7/9/02
%
global tn ufn sn K; y=s(2); 
th1=interp1(tn,ufn,t); sn1=interp1(tn,sn,t);
y1=sn1(2); K1=interp1(tn,K,t);
th=th1-K1(2)*(y-y1); co=cos(th); si=sin(th);
sp=[(1+y)*co; (1+y)*si];

		
	 
	   
	
	
