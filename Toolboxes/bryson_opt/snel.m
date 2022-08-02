function f=snel(p,v1,v2,y1,y2,x2)
% Subroutine for p1_2_05.m; min time path thru region with 2 layers of
% const. velocity magnitude using Snell's law and FSOLVE;      5/20/98
%
th1=p(1); th2=p(2);
f=[x2-y1*tan(th1)-(y2-y1)*tan(th2); v2*sin(th1)-v1*tan(th2)];

