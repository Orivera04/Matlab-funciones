function f=oscnmp(p)
% Function file for p10_2_2.m; solves LQ pb. for oscillatory NMP
% system;                                                       9/7/98
%
uo=15; t1=p(1); t2=p(2); tf=1.5; x1o=2; x2o=2;
x11=-uo+(x1o+uo)*cos(t1)+(x2o+uo)*sin(t1);
x21=-uo-(x1o+uo)*sin(t1)+(x2o+uo)*cos(t1);
dt1=t2-t1; x12=x11*exp(-dt1); x22=x21*exp(dt1); dt2=tf-t2;
x1f=uo+(x12-uo)*cos(dt2)+(x22-uo)*sin(dt2);
x2f=uo-(x12-uo)*sin(dt2)+(x22-uo)*cos(dt2);
f=[x1f; x2f];

