% Script p2_6_3n.m; min distance to a meridian on a sphere using
% FOP0N;                                           4/97, 7/15/02
%
c=180/pi; th0=40/c; phf=50/c; s0=[0 th0]'; tf=phf; N=20; 
N1=N+1; u0=.6*ones(1,N1); name='geo0'; 
optn=optimset('Display','Iter','MaxIter',100);
u=fsolve('fop0n',u0,optn,name,s0,tf);
[f,s,la0]=fop0n(u,name,s0,tf); th=c*s(2,:);
ph=c*phf*[0:N]/N;
%
figure(1); clf; plot(ph,th,ph,th,'b.',ph(1),th(1),'ro',...
    ph(N1),th(N1),'ro'); grid; xlabel('Longitude \phi (deg)')
ylabel('Latitude \theta (deg)')
