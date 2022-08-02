function yp=gdd_3(t,y)
% Goddard problem by forward integration; in GDD_1, t1 found so that 
% m=(1+v/c)D (the singular surface) at t=t1; in GDD_1, t2 found so that
% m(t2)=mf; kere tf found so that v(tf)=0;          6/94, 1/96, 9/10/98
%
c=.5;  be=500; B=620; Tmax=3.5; mf=.6; r=y(1); v=y(2); m=y(3);
D=B*v^2*exp(be*(1-r))/2; T=0;
yp=[v; (T-D)/m-1/r^2; -T/c];
