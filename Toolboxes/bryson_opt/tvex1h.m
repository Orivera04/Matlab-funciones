% Script tvex1h.m; Time-Varying EXample of 1st order LQ 
% optimization; dot(x)=-t*x+u; J=int[0:tf](u^2/2)dt,
% x(0)=x0; x(tf)=sf;                                 8/5/02
%
tf=2; s0=1; sf=.8; name='tvex_h';
[t,y]=tvlqh(name,tf,s0,sf); x=y(:,1); u=-y(:,2);
%
% Analytical solution:
N=50; t1=tf*[0:1/N:1]; a=exp(t1.^2); b=cumtrapz(a);
la0=(s0-sf*exp(tf^2/2))/b(N+1); un=ones(1,N+1);
c=sqrt(a); ua=-la0*c; xa=(s0*un-la0*b)./c;
%
figure(1); clf; subplot(211), plot(t,x,t1,xa,'r--'); grid
legend('x','x_a'); subplot(212), plot(t,u,t1,ua,'r--'); 
grid; legend('u','u_a',2); xlabel('Time')
