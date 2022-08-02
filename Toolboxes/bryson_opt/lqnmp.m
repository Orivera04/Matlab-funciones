function f=lqnmp(p)
% Subroutine for e10_2_1a.m;         9/96, 1/98, 6/98, 9/7/98
x1o=1; x2o=1; tf=1.5; uo=8; t1=p(1); t2=p(2); 
x11=x1o+(x2o+uo)*t1-uo*t1^2/2; x21=x2o-uo*t1;
dt1=t2-t1; x12=x11*exp(-dt1); x22=x21*exp(dt1)+x11*sinh(dt1);
dt2=tf-t2; x1f=x12+(x22-uo)*dt2+uo*dt2^2/2; x2f=x22+uo*dt2;
f=[x1f x2f];
