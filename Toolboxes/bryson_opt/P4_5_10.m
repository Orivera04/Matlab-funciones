% Script p4_5_10.m; TDP for min tf to vf=0, and specified (uf,yf,xf)
% with gravity;  s=[u v y x]'; (u,v) in uf, (x,y) in uf^2/a, t in
% uf/a;			                                       2/97, 7/16/02
%
clear; clear global; global yf xf g; yf=.2/.4577^2; xf=.15/.4577^2; 
g=1/3; name='tdpgxt'; told=1e-4; tols=1e-4; mxit=10;
th0=[1.596 1.578 1.558 1.533 1.502 1.464 1.416 1.352 1.265 ...
     1.142 .961 .697 .341 -.046 -.367 -.592 -.744 -.850 -.925 ...
     -.982  -1.025]'; tf=1/.4577; N=length(th0)-1;
tu=tf*[0:1/N:1]'; s0=zeros(4,1); k=.3;
[t,th,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4);
N1=length(u); th=th*180/pi;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;
axis([-.2 1.13 0 1]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2'); 
%
figure(2); clf; subplot(211), plot(t,th); grid;
ylabel('\theta (deg)'); axis([0 2.3 -100 100]); subplot(212),
plot(t,u,t,v,'r--'); grid; xlabel('at/u_f');  axis([0 2.3 -.1 1]);
legend('u/u_f','v/u_f',2);	
	