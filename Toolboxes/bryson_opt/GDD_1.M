function yp=gdd_1(t,y)           
% Goddard problem by forward integration; t1 found here so that
% m=(1+v/c)D (the singular surface); in 'gdd_2' t2 found so that
% m(t2)=mf; in 'gdd_3' tf found so that v(tf)=0. 6/94, 1/96, 9/10/98
%
c=.5; be=500; B=620; Tmax=3.5; mf=.6; r=y(1); v=y(2); m=y(3);
D=B*v^2*exp(be*(1-r))/2; T=Tmax;
yp=[v; (T-D)/m-1/r^2; -T/c];
