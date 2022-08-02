% Script p4_5_04.m; VDP for min time to a point with V=1+y 
% (Fermat Pb.);                                  11/96, 7/16/02
%
clear; clear global; global xf yf; xf=2.33 ; yf=0; name='frmt';
th0=[.8:-.1:-.8]'; tf=2; N=length(th0)-1; tu=tf*[0:1/N:1]';
s0=[0 0]'; k=.3; told=1e-4; tols=1e-4; mxit=20;
[t,u,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); 
%	
figure(1); clf; plot(x,y,xf,yf,'ro',0,0,'ro'); grid
xlabel('x'); ylabel('y'); axis([0 2.5 -.25*2.5 .5*2.5])
