function [f,tf,m,al]=tdpxt_f(p,yf,xf);
% Subroutine for p4_3_07; TDP for min tf to vf=0 & spec. (uf,yf,xf);
% (u,v) in uf, (x,y) in uf^2/a, t in uf/a, g in a; 2/96, 6/98, 9/14/98
%
th0=p(1); thf=p(2); fu=asinh(tan(th0))-asinh(tan(thf));
fv=sec(th0)-sec(thf); ft=tan(th0)-tan(thf); fx=fv-tan(thf)*fu;
fy=(sec(th0)*ft-tan(thf)*fv-fu)/2; m=sqrt(fu^2+fv^2); tf=ft/m;
al=-atan2(fv,fu); M=[cos(al) -sin(al); sin(al) cos(al)];
xy=M*[fx;fy]/m^2; xf1=xy(1); yf1=xy(2); f=[xf-xf1 yf-yf1];
	
	
	
	