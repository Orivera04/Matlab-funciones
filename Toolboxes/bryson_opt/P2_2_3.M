% Script p2_2_03.m; DVDP for min distance to a meridian
% on a sphere using DOP0;                    6/98, 3/30/02
%
N=40; be0=.2*ones(1,N); c=pi/180; s0=[0 c*40]'; phf=c*50; 
k=10; tol=1e-4; mxit=50; 
[be,s,la0]=dop0('dgeo0',be0,s0,phf,k,tol,mxit);
beh=[be be(N)]/c; th=s(2,:)/c; ph=phf*[0:1/N:1]/c; N1=N+1;
%
figure(1); clf; subplot(211),plot(ph,th,'.',ph,th,...
    ph(N1),th(N1),'ro'); grid; axis([0 50 40 54]) 
ylabel('Latitude \theta(deg)'); subplot(212), 
zohplot(ph,beh); ylabel('Heading Angle \beta (deg)')
grid; xlabel('Longitude \phi (deg)')
	
