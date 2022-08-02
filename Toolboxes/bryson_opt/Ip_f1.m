function f=ip_f1(p,ep,umax)               
% Subroutine for Pb. 9.3.13b; erection of an inverted pendulum using 
% inverse dyn. opt. and CONSTR or FMINCOM; cart mass=M, pend. mass=m;
% s=[th q x v]'; time in units of sqrt(l/g), x in l, m in (M+m), u in
% (M+m)g; ep=m/(M+m); |u|<=umax;                              4/17/98
%
N=(1+length(p))/2; tf=p(2*N-1); f=tf;
