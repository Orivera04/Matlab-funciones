function [f,m,al]=tdpx_f(p,xf,yf);
% Subroutine for Pb. 3.3.7; TDP for max uf with vf=0 and specified
% (yf,xf); th=control; 	                             2/97, 9/10/97
%
b0=p(1); b=p(2); m=tan(b0)-tan(b); fu=asinh(tan(b0))-asinh(tan(b));
fv=sec(b0)-sec(b); fx=fv-tan(b)*fu; fy=(sec(b0)*m-tan(b)*fv-fu)/2;
al=-atan2(fv,fu); M=[cos(al) -sin(al); sin(al) cos(al)];
xy=M*[fx; fy]/m^2; xf1=xy(1); yf1=xy(2);
yf=.2; xf=.2; f=[yf-yf1 xf-xf1]';
	
	