function [f,m,al]=tdpgx_f(p,yf,xf,g) 
% Subroutine for Pb. 3.3.10; TDP for max uf with gravity, vf=0, & spec.
% (tf,yf,xf); th=control; 	                               2/97, 6/13/98
%
th0=p(1); thf=p(2); m=tan(th0)-tan(thf); 
fu=asinh(tan(th0))-asinh(tan(thf)); fv=sec(th0)-sec(thf);
fx=fv-tan(thf)*fu; fy=(sec(th0)*m-tan(thf)*fv-fu)/2;
al=atan2(yf+g/2,xf)-atan2(fy,fx); m=(fu*sin(al)+fv*cos(al))/g;
M=[cos(al) -sin(al); sin(al) cos(al)]; xy=M*[fx; fy]/m^2; x=xy(1);
y=xy(2)-g/2; f=[y-yf x-xf]';
	
	