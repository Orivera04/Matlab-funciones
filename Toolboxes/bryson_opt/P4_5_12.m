% Script p4_5_12.m; VDP for min time to (xf,yf) with gravity, thrust,
% and drag; s=[V x y]';                                 1/94, 7/16/02
%
clear; clear global; global xf yf a; a=.05; yf=-.3; xf=1.98; 
name='vdpgtdt'; N=30; tf=5;  ga0=-.16*ones(N+1,1); tu=tf*[0:1/N:1]';
s0=[0 0 0]'; k=.2; told=1e-4; tols=1e-4; mxit=20;
[t,ga,s,tf,nu,la0]=fopt(name,tu,ga0,tf,s0,k,told,tols,mxit); v=s(:,1);
x=s(:,2); y=s(:,3); c=180/pi; ga=ga*c; N1=length(x); ke=v.^2/2;
% 
figure(1); clf; subplot(211), plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; xlabel('x/l'); ylabel('y/l'); axis([ 0 2 -.4 0]);  
subplot(212); plot(ke,y,ke(N1),y(N1),'ro',0,0,'ro'); grid;
xlabel('V^2/2gl'); ylabel('y/l'); axis([ 0 .12 -.4 0]);
%
figure(2); clf; plot(t,ga); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)'); axis([0 5 -90 70]);

	
	