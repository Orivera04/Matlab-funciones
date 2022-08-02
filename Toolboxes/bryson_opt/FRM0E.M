function yp=frm0e(t,y)
% Subroutine for Pb. 2.6.4f,b; EL eqns. for shooting soln; max range 
% with V=1+y (Fermat Pb.);                                    2/21/97
%
x=y(1); y1=y(2); lx=y(3); ly=y(4); th=atan(ly); c=cos(th); s=sin(th);
yp=[(1+y1)*c (1+y1)*s 0 -lx*c-ly*s]';
	
	
	 
	   
	
	
