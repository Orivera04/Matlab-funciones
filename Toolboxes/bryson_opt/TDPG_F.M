function [f,m]=tdpg_f(p,yf,g);
% Subroutine for Pb. 3.3.9; TDP for max uf with gravity to v(tf)=0, spec.
% (tf,yf); th = control; t in tf, (u,v) in a*tf, (x,y) in a*tf^2, g in a;
%                                                           2/97, 6/12/98
%
th0=p; c=sec(th0)-g*tan(th0); thf=atan((c*g-sqrt(c^2-1+g^2))/(1-g^2));  
m=tan(th0)-tan(thf); u=(1/m)*(asinh(tan(th0))-asinh(tan(thf)));
y=(.5/m)*(sec(th0)-tan(thf)*g-u)-g/2; f=y-yf;
	
	