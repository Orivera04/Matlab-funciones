% Script p4_5_02.m; min tf to a point with uc=Vy/h; s=[x y]' 
% in units of h, t in units of h/V;           11/96, 7/16/02
%
clear; clear global; global xf yf; name='zrmt'; N=20; yf=0; 
xf=11.3; th0=pi/3*[1:-2/N:-1]'; tf=6; tu=tf*[0:1/N:1]'; 
k=.4; s0=[0 0]'; told=1e-4; tols=1e-4; mxit=40;
[t,u,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N1=length(x);  
%
figure(1); clf; subplot(211), plot(x,y,0,0,'ro',x(N1),...
    y(N1),'ro'); grid; axis([0 12 0 3]); xlabel('x/h')
ylabel('y/h')
   

       
       