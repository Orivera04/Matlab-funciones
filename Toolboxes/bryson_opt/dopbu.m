function f=dopbu(z0,name,s,la,dt,t)
% Subroutine for DOP0B; for use with FSOLVE to find z=[u(i),s(i)] given
% [s=s(:,i+1),la=lambda(:,i+1)] and an initial guess z0;         1/1/98
%
ns=length(s); u1=z0(1); s1=z0([2:ns+1]); fi=feval(name,u1,s1,dt,t,1);
[fs,fu]=feval(name,u1,s1,dt,t,3); f=[s-fi; fu'*la];