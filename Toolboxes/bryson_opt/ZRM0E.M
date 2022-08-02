function yp=zrm0e(t,y)
% Subroutine for Pb. 2.6.2f,b; EL eqns. for shooting solution of max
% range with uc=Vo(1+y/h);                                   3/28/97
%
y1=y(2); lx=y(3); ly=y(4); th=atan(ly);
yp=[cos(th)+y1 sin(th) 0 -lx]';