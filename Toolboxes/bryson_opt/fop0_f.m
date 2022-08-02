function yp=fop0_f(t,s,flag,tu,u,name)
% Subroutine for FOP0 - fwd integ. sdot=f(s,u); 
%                                 8/97, 3/12/02
%
u1=interp1(tu,u,t); yp=feval(name,u1,s,t,1); 