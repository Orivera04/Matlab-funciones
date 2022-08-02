% Script p2_7_8.m; TDP for max uf w. spec. (vf,yf) using FOP0,
% s=[u v y x]'; (cf. p3_4_06.m)                         7/1/02
%
load p2_7_8; name='tdp0'; s0=zeros(4,1); tf=1; k=-1e-4; 
told=1e-4; tols=1e-4; mxit=5; 
[t,th,s]=fop0(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); N1=length(t);
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .4 0 .3]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,180*th/pi); grid
ylabel('\theta (deg)'); axis([0 1 -70 70]) 
subplot(212), plot(t,[u v]); grid; xlabel('t/t_f')
axis([0 1 0 .8]); legend('u/at_f','v/at_f',2)
