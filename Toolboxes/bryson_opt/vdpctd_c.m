function [ceq,c,y1,y2,xf]=vdpctd_c(p,a,tf,yf)
% Subroutine for p3_3_12, p3_4_12, 3_6_12; approx. max range with thrust, 
% gravity, drag, & spec. yf using vertical dive, constant ga=gac, then
% vertical climb;                                            2/98, 6/22/98
%
gac=p(1); t2=p(2); vc=sqrt(a-sin(gac)); e=sqrt(1+a); t1=atanh(vc/e)/e;
y1=-log(cosh(e*t1)); y2=y1+vc*sin(gac)*(t2-t1); d=sqrt(1-a); b=atan(vc/d);
xf=vc*cos(gac)*(t2-t1); 
ceq=yf-(y2-log((sec(b-d*(tf-t2)))/sec(b)));
c=[];

