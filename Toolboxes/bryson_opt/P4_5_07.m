% Script p4_5_07.m; TDP for min tf to vf=0 and spec. (uf,yf,xf);
% s=[u v y x]'; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                   2/97, 7/16/02
%
clear; clear global; global yf xf; yf=.2/.4875^2; xf=.15/.4875^2;   
name='tdpxt'; th0=[1:-.1:-1]'; c=180/pi; N=length(th0)-1;
tf=1/.4875; tu=tf*[0:1/N:1]'; s0=zeros(4,1); k=1; told=1e-4; 
tols=1e-4; mxit=10;
[t,th,s,tf]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); N1=length(u); th=th*c;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;
xlabel('ax/u_f^2'); ylabel('ay/u_f^2'); axis([-.3 .9 0 .9]); 
%
figure(2); clf; subplot(211), plot(t,th); grid
ylabel('\theta (deg)'); axis([0 2.2 -60 120]); subplot(212),
plot(t,u,t,v,'r--'); grid; xlabel('at/u_f'); 
axis([0 2.2 -.2 1 ]); legend('u/u_f','v/u_f',2);

	