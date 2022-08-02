function [f,m,tf]=tdpgt_f(p,yf,g);
% Subroutine for p4_3_09; TDP for min tf with gravity to v(tf)=0, spec.
% (uf,yf); th=control; t in uf/a, (u,v) in uf, (x,y) in uf^2/a, g in a;
%                                                         2/97, 6/25/98
%
th0=p; c=sec(th0)-g*tan(th0); thf=atan((c*g-sqrt(c^2+g^2-1))/(1-g^2));  
m=asinh(tan(th0))-asinh(tan(thf));ft=(tan(th0)-tan(thf)); tf=ft/m;
fv=sec(th0)-sec(thf); v1=fv/m; v=v1-g*tf; 	
y=(.5/m)*(sec(th0)*tf-tan(thf)*v1-1)-g*tf^2/2; f=y-yf;
	

	