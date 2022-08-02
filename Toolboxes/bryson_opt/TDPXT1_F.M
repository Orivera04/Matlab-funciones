function [f,tf,bef]=tdpxt1_f(p,Vf,gaf);
% Subroutine for Pb. 7.3.6; TDP for min tf to vf=0 & spec.
% (Vf,gaf); (u,v) in uf, Vf in sqrt(2a*rf), t in Vf/a;  
%                                             1/97, 7/23/02
%
thb0=p(1); thbf=p(2); fu=asinh(tan(thb0))-asinh(tan(thbf));
fv=sec(thb0)-sec(thbf); ft=tan(thb0)-tan(thbf);
fx=fv-tan(thbf)*fu; fy=(sec(thb0)*ft-tan(thbf)*fv-fu)/2;
m=sqrt(fu^2+fv^2); al=-atan2(fv,fu);
rf=sqrt(fx^2+fy^2)/m^2; Vf1=1/sqrt(2*rf);  
sgbf=atan2(fy,fx); gaf1=sgbf+al;
f=[Vf-Vf1 gaf-gaf1];
%
tf=ft/m; bef=sgbf-thbf; 
	
	