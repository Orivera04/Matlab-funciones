function f=geot_f(p,th0,thf,phf)
% Subroutine for p4_3_03; min distance to a point  on a sphere; 
% th=latitude, ph=longitude, t=distance along the path; 12/96, 6/25/98
%
thm=p(1); tf=p(2); s=sin(thm); ct=cos(thm); al=asin(sin(th0)/s); 
th=asin(s*sin(tf+al)); b=atan(ct*tan(tf+al)); d=atan(ct*tan(al));
if b>0, ph=b-d; else ph=b-d+pi; end; f=[th-thf ph-phf];
	
	
	
