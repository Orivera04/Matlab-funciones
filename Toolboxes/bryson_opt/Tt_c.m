function [c,ceq,x,y,ps,u]=tt_fg(p,N,sf,uo)
% Subroutine for Pb. 10.3.3;   1/97, 3/29/02
%
% Estimate of al history and tf:
psf=sf(1); alf=sf(2); yf=sf(3); xf=sf(4); al=[0 p(1:N-1) alf];
tf=p(N); dt=tf/N; ald=(al(2:N+1)-al(1:N))/dt; 
alb=(al(2:N+1)+al(1:N))/2; u=ald+sin(alb);
%
% Integrate to get psi:
ps(1)=0; for i=1:N, ps(i+1)=ps(i)+dt*u(i); end
psb=(ps(2:N+1)+ps(1:N))/2;
%
% Integrate to get (x,y) and inequality constraint |u| <= uo;
y(1)=0; x(1)=0; for i=1:N,
 y(i+1)=y(i)+dt*sin(psb(i)); x(i+1)=x(i)+dt*cos(psb(i));
 c(i)=abs(u(i))-uo; end
%
% Performance index and terminal equality constraints:
ceq=[y(N+1)-yf x(N+1)-xf ps(N+1)-psf]; 
	