function [f,g,t,x]=ipz(ts,ep,umax)               
% Subroutine for Pb. 9.3.13z; erection of an inverted pendulum using 
% force u on cart; cart mass=M, pend. mass=m; |u|<=umax;
% s=[th q x v]'; ts=vector of switching times + final time; time in 
% units of sqrt(l/g), x in l, m in (M+m), u in (M+m)g;         12/6/01
%
x0=zeros(4,1); xfd=[pi 0 0 0]; 
[t,x]=ode23('ipez',[0 ts],x0,[],ts,ep,umax);
f=ts(6); m=length(t); xf0=x(m,:); 
g=xf0-xfd;
