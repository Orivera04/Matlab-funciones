% Script p4_3_03.m; DVDP for min distance between points on a sphere
% (Tokyo to New York) using distance along the path as independent 
% variable; based on APPROXIMATE system eqns;          2/98, 3/29/02
%
global thf phf; c=pi/180; N=40; u=[1:-2/N:-1+2/N]; s0=[35.7*c 0]';
phf=2*pi-c*(139.7+73.8); k=10; thf=40.7*c; tol=1e-4; mxit=100; 
tf=1.7040; [u,s,tf,nu,la0]=dopt('dgeot',u,s0,tf,k,tol,mxit);
uh=[u u(N)]/c; th=s(1,:)/c; ph=s(2,:)/c; N1=N+1;  
% 
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'ro',360-(139.7+145),70,'ro',0,th(1),'ro'); axis([0 150 30 75])
grid; text(5,35,'Tokyo'); text(120,42,'New York') 
text(55,64,'Prudhoe Bay, Alaska'); ylabel('Lat. \theta (deg)')
subplot(212), zohplot(ph,uh); grid; ylabel('Heading \beta (deg)')
xlabel('Long. Diff. \phi-\phi_0 (deg)') 
	
	
