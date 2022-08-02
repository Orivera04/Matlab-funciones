% Script p4_2_3a.m; DVDP for min distance to a point on a sphere using 
% FSOLVE (Tokyo to NY) on the APPROXIMATE EL eqns ;      2/98, 3/29/02
%
N=20; c=pi/180; th0=35.7*c; thf=40.7*c; phf=2*pi-139.7*c-73.8*c;
be=[1:-2/N:-1+2/N]; nu=[0 0]; dt=1.7/N; p=[be nu dt]; N1=N+1; 
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dgeot_fa',p,optn,th0,thf,phf);
[f,th,ph]=dgeot_fa(p,th0,thf,phf); be=p([1:N]); beh=[be be(N)]/c;
dt=p(N+3); t=dt*[0:N]; th=th/c; ph=ph/c;
%
figure(1); clf; subplot(211),plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'o',0,th(1),'o',360-139.7-145,70,'o'); grid; axis([0 150 30 75]); 
text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); ylabel('Latitude \theta (deg)');
subplot(212), zohplot(ph,beh); grid;
ylabel('Heading Angle \beta (deg)'); xlabel('Longitude \phi (deg)'); 
	
	