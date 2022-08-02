function [f,th,q,Q]=pend_f(p,th0,q0,N)                            
% Min time control of a pendulum with -1<=Q<=1;   4/12/98
%
q=[q0 p(1:N-1) 0]; qb=(q(2:N+1)+q(1:N))/2; tf=p(N); dt=tf/N;
th(1)=th0; for i=1:N, th(i+1)=th(i)+dt*qb(i); end;
thb=(th(2:N+1)+th(1:N))/2; Q=(q(2:N+1)-q(1:N))/dt+thb; 
f=tf; 