% Script p4_3_03a.m; DVDP for min distance between two points on a 
% sphere (Tokyo to NY) using FMINCON ;               2/98, 3/29/02
%
N=40; z=pi/180; th0=35.7*z; thf=40.7*z; phf=2*pi-z*(139.7+73.8);
be0=[1:-2/N:-1+2/N]; tf=1.7; p0=[be0 tf]; N1=N+1;  

p=fmincon('dgeot_f1',p0,[],[],[],[],[],[],'dgeot_c',optn,th0,thf,phf);
[c,ceq,th,ph]=dgeot_c(p,th0,thf,phf); be=p([1:N]);
beh=[be be(N)]/z; tf=p(N+1); dphpb=360-(139.7+145); th=th/z; ph=ph/z;
%
figure(1); clf; subplot(211),plot(ph,th,ph,th,'b.',ph(N1),th(N1),...
   'ro',0,th(1),'ro',dphpb,70,'ro'); grid; axis([0 150 30 75]) 
text(5,35,'Tokyo'); text(120,42,'New York');
text(65,64,'Prudhoe Bay, Alaska'); ylabel('Latitude \theta (deg)')
subplot(212), zohplot(ph,beh); grid
ylabel('Heading Angle \beta (deg)'); xlabel('Longitude \phi (deg)') 
	
	 