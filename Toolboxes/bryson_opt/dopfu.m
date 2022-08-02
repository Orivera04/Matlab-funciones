function f=dopfu(p0,name,s,la,dt,t)
% Subroutine for DOP0F; finds p=[u(i) lambda(i+1)] given
% [s(:,i) lambda(i)] and initial guess p0; rev. 6/18/02
%
[ns,dum]=size(s); u1=p0(1); l1=p0([2:ns+1]);
[fs,fu]=feval(name,u1,s,dt,t,3);
f=[fs'*l1-la; fu'*l1];