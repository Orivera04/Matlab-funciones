function [f1,f2]=dvdp0td(ga,s,dt,t,flg)                            
% Subroutine for Pbs. 2.2.6, 2.5.6; DVDP for max range w. gravity, thrust,
% and drag; s=[v x y]'; ga=control; t in sqrt(l/g), v in sqrt(gl), a in g,
% (x,y) in l;%                                         5/97, 2/98, 6/24/98          
%
global a; s=real(s); ga=real(ga); v=s(1); x=s(2); y=s(3); co=cos(ga);
si=sin(ga); b=sqrt(a-si); g=atanh(v/b); g1=dt*b+g; cg=cosh(g);
cg1=cosh(g1); tg=tanh(g); tg1=tanh(g1); bg=-co/(2*b); gv=b/(b^2-v^2);
gg=-v*bg/(b^2-v^2); e=real(log(cg1/cg));
if flg==1, f1=[b*tg1; x+co*e; y+si*e];
elseif flg==2, f1=x; f2=[0 1 0]; 
elseif flg==3,
 f1=[gv*b/(cg1)^2 0 0; gv*co*(tg1-tg) 1 0; gv*si*(tg1-tg) 0 1];                      
 f2=[bg*tg1+b*(bg*dt+gg)/(cg1)^2; -si*e+co*((bg*dt+gg)*tg1-gg*tg);...
     co*e+si*((bg*dt+gg)*tg1-gg*tg)];
end;
	 

