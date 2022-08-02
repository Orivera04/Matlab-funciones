function yp=gdd_2(t,y)              
% Goddard problem by forward integration; in 'gdd_1', t1 found so that 
% m=(1+v/c)D (the singular surface) at t=t1; here, t2 found so that
% m(t2)=mf; in 'gdd_3', tf found so that v(tf)=0. 6/94, 1/96, 9/10/98
%
c=.5; be=500; B=620; Tmax=3.5; mf=.6; r=y(1); v=y(2); m=y(3);
D=B*v^2*exp(be*(1-r))/2; g=1/r^2;
num=D*(1+2*c/v-be*c^2*(1+v/c)/g)+2*c^2/(g*r);
den=D*(1+4*c/v+2*c^2/v^2); T=D+m/r^2-m*num/den;
yp=[v; (T-D)/m-1/r^2; -T/c];
