function yp=fop0_b(t,y,flag,tu,u,ts,s,name)
% Subroutine for FOP0;          2/98, 3/13/02
%
la=y; u1=interp1(tu,u,t); s1=interp1(ts,s,t);
fs=feval(name,u1,s1,t,3); yp=-fs'*la;