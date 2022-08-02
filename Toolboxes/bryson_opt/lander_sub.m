function sp=lander_sub(t,s,v0,Isp,Tmax)
% Subroutine for ross.dyn;     9/11/02
%
v=s(2); m=s(3);
sp=[v; -1+Tmax/m; -Tmax/Isp];
