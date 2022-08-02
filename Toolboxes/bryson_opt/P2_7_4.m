% Script p2_7_4.m; max range in given time w. V=1+y & specified
% yf (Fermat Pb.) using a penalty function;        2/97, 7/2/02
%
global yf sy; yf=0; sy=2e2; 
load p2_7_4; u0=u0'; tu=tu';
name='frm0y'; N=20; tf=2; %tu=tf*[0:1/N:1]'; u=.5*ones(N+1,1);
s0=[0 0]'; k=-1e-3; told=1e-4; tols=1e-4; mxit=10;
[t,u,s,la0]=fop0(name,tu,u0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N1=length(x);
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid 
axis([0 2.5 0 .75*2.5]); xlabel('x'); ylabel('y')
	
	 
	   
	
	
