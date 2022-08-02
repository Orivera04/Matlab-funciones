% Script p3_4_06.m; TDP for max uf and spec. (vf,yf); 
% s=[u v y x]';                                   6/97, 7/16/02
%
name='tdpc'; th0=[1:-.05:-1]'; s0=zeros(4,1); tf=1; k=-.3; 
N=length(th0)-1; tu=tf*[0:1/N:1]'; told=1e-4; tols=1e-4;
mxit=100; [t,th,s]=fopc(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); c=180/pi; N1=length(t);
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .36 0 .27]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,c*th); grid
ylabel('\theta (deg)'); axis tight; subplot(212), plot(t,[u v]);
grid; xlabel('t/t_f'); axis tight; legend('u/at_f','v/at_f',2)

	