function [f,m]=tdp_f(p,yf);
% Subroutine for e03_3_1 & p3_3_6; TDP for max uf to vf=0, spec. (tf,yf);
% (u,v) in a*tf, (x,y) in a*tf^2, t in tf;	               2/97, 6/27/98
%
th0=p; m=2*tan(th0);	u=(2/m)*asinh(tan(th0)); y=(.5/m)*(sec(th0)-u);
f=y-yf;
	
	