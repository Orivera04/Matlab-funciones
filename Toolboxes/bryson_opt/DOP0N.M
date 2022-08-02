function [f,s,la0]=dop0n(u,name,s0,tf)                    
%DOP0N - Disc. OPtim. w. 0 term. constr., Newton-Raph.
%[f,s,la0]=dop0n(u,name,s0,tf)   
% Uses FSOLVE for a NR-type algor; function file 'name' should be
% in the MATLAB path & calculate f for flg=1, (phi,phis) for flg=2,
% and (fs,fu) for flg=3; u=initial guess of (scalar) control
% sequence, s0=initial state, tf=final time; s=optimal state vector
% sequence, la0=la(0);  		                      4/97, 6/18/02 
%
N=length(u); ns=length(s0); dt=tf/N; s(:,1)=s0;   
for i=1:N
  t=(i-1)*dt; s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
end
[phi,phis]=feval(name,0,s(:,N+1),0,0,2); la=phis'; 
for i=N:-1:1
 t=(i-1)*dt; [fs,fu]=feval(name,u(i),s(:,i),dt,t,3);
 Hu(i)=la'*fu; la=fs'*la;
end; la0=la;
f=Hu;
	 

