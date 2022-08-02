% Script p3_4_04.m; VDP for max range with V=1+y & specified
% yf; (Fermat Pb.) using FOPC;                11/96, 7/16/02
%
global yf; yf=0; name='frmc'; s0=[0 0]'; th0=[.8:-.05:-.8]';
tf=2; N=length(th0)-1; mxit=15; tu=tf*[0:1/N:1]'; k=-.3;
told=1e-5; tols=5e-4; 
[t,u,s]=fopc(name,tu,th0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N1=length(x); 
%	
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('x'); ylabel('y'); axis([0 2.5 -.6 1.28])
