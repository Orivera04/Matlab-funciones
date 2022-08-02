% Script p3_1_03.m; DVDP for min distance between two points 
% on a sphere (Tokyo to New York), solving the EXACT EL eqns.
% using FSOLVE;                                 6/98, 3/30/02
%
c=pi/180; th0=35.7*c; thf=40.7*c; phny=-73.8*c; ph0=139.7*c;
phf=2*pi-ph0+phny; optn(1)=1; optn(14)=1000; be0=c*[50:-9:-40];
laf0=.9; p0=[be0 laf0]; p=fsolve('dgeo2',p0,optn,th0,thf,phf);
[f,th,s]=dgeo2(p,th0,thf,phf); N=length(be0);
ph=phf*[0:1/N:1]/c; th=th/c; be=p([1:N]); beh=[be be(N)]/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',0,th(1),...
   'ro',phf/c,th(N+1),'ro',360-ph0/c-145,70,'ro'); grid 
axis([0 150 30 75]); ylabel('Latitude \theta (deg)')
text(5,35,'Tokyo'); text(130,42,'New York') 
text(65,64,'Prudhoe Bay, Alaska'); subplot(212), 
zohplot(ph,beh); grid; xlabel('Longitude \phi-\phi_0 (deg)') 
ylabel('Heading Angle \beta (deg)')
	
	
	
