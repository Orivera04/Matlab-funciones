function f=maxcltn(p,ga,flg)
% Subroutine for p1_2_13, find min climbing turn radius (flg=1) or max
% climbing turn rate (flg=2); p=[V alpha sigma];         10/96, 9/10/98
%
V=p(1); al=p(2); sg=p(3); T=.2; alm=1/12; eta=.5; ep=2*pi/180; 
f(1)=sin(ga)-T*cos(al+ep)+eta*V^2*(al^2+alm^2);
f(2)=cos(ga)-cos(sg)*(T*sin(al+ep)+V^2*al);
if flg==1, f(3)=eta*(al+alm^2/al)*(T*cos(al+ep)+V^2)-(cos(sg))^2*...
	      (T*sin(al+ep)+2*eta*V^2*al);
elseif flg==2,  f(3)=2*eta*(al+alm^2/al)*(T*cos(al+ep)+V^2)-...
         (1+(cos(sg))^2)*(T*sin(al+ep)+2*eta*V^2*al);
end