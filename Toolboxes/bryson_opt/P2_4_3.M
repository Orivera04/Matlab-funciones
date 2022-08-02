% Script p2_4_3.m; min dist. from point to meridian on a sphere;
%                                                      2/97, 7/2/02
%
name='geo0'; N=20; c=180/pi; tf=50/c; u=.6*ones(N+1,1); 
tu=tf*[0:1/N:1]'; s0=[0 40/c]'; k=1; told=1e-5; tols=1e-4; mxit=50;
[t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);
ph=c*t; th=c*s(:,2); N1=length(ph); 
%
figure(1); clf; plot(ph,th,ph(1),th(1),'ro',ph(N1),th(N1),'ro'); 
grid; xlabel('Long. \phi (deg)'); ylabel('Lat. \theta (deg)')
