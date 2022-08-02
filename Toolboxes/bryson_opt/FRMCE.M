function yp=frmce(t,s)
% Subroutine for Pb. 3.6.4; EL eqns. for shooting soln; max range 
% with V=1+y (Fermat Pb.);                                 4/1/97
%
x=s(1); y=s(2); lx=s(3); ly=s(4); th=atan(ly); c=cos(th);
s=sin(th); yp=[(1+y)*c (1+y)*s 0 -lx*c-ly*s]';
	
	
	 
	   
	
	
