function sp=zrmce(t,s)
% Subroutine for Pb. 3.6.2; EL eqns. for shooting solution of max range 
% with uc=Vo(1+y/h) & specified yf;                              4/5/97
%
y=s(2); lx=s(3); ly=s(4); th=atan(ly);
sp=[cos(th)+y sin(th) 0 -lx]';