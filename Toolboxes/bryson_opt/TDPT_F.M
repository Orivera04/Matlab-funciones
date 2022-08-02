function [f,m,tf]=tdpt_f(p,yf);
% Subroutine for p4_3_06; TDP for min tf to vf=0, uf=1, & spec. yf; 
% vf=0 ==>thf=-th0; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                     1/97, 6/25/98
%
th0=p; m=2*asinh(tan(th0)); tf=2*tan(th0)/m;
y=(1/m)^2*(sec(th0)*tan(th0)-m/2); 	f=y-yf;
	
	