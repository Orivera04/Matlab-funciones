function f1=ipen(u,s,t,flg)      
% Subsubroutine for Pb.9_3_13b, erection of inverted pendulum with hori-
% zontal force on cart using CONSTR; cart mass = M, pend. mass = m; 
% y=[th q x v]'; time in sqrt(l/g), x in l, m in (M+m), u in (M+m)g,
% |u|<=umax, ep=m/(M+m);                                         4/16/98
%
ep=.5; th=s(1); q=s(2); v=s(4); si=sin(th); c=cos(th);
A=[1 ep*c; c 1]; b=[u+ep*si*q^2; -si]; vqd=A\b; 
if flg==1, f1=[q; vqd(2); v; vqd(1)]; end
