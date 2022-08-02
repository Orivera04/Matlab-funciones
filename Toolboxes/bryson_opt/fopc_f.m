function yp=fopc_f(t,s,flag,tu,u,name)
% Subroutine for FOPC; fwd integ. sdot=f(s,u); 2/98, 7/16/02
%
u=interp1(tu,u,t); 
yp=feval(name,u,s,t,1); 