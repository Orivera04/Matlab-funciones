function f=ferm0(p,tf)
% Subroutine for p2_3_4; calculates tf given theta_0; max range xf with
% V=1+y;                                             10/96, 1/98, 6/23/98
%
tho=p; f=tf-log(sec(tho)+tan(tho));   
	
	
