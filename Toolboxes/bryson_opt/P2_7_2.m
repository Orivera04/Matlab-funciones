% Script p2_7_2.m; max range in given time with uc=y/h 
% (Zermelo Pb.)& soft TC on y(tf), using FOP0; (see Pb. 8.5.2
% for NR 2nd order numerical solution);                   7/2/02
%
global sy yf; sy=2e2; yf=0; tf=2; name='zrm0y'; mxit=5; 
load p2_7_2; s0=[0 0]'; k=-.01; told=1e-5; tols=1e-5; 
[t,u,s]=fop0(name,tu',u0',tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N=length(t); tu=t; u0=u;
% 
figure(1); clf; subplot(211), plot(x,y,x(N),y(N),'ro',0,0,'ro'); 
axis([0 2.4 0 .6]); grid; xlabel('x/h'); ylabel('y/h')
subplot(212), plot(t,180*u/pi); grid; ylabel('\theta (deg)')
xlabel('Time')
	

	
	