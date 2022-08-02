% Script p4_2_03.m; DVDP for min distance to a point on a sphere using 
% FSOLVE (Tokyo to New York) with the exact EL eqns; NOTE constant
% heading paths on a sphere are called "loxodromic spirals"; thus the
% paths here consist of N loxodromic spiral segments of equal path
% length;                                               2/98, 3/29/02
%
N=20; c=pi/180; th0=35.7*c; thf=40.7*c; phf=2*pi-c*(139.7+73.8);
be=[1:-2/N:-1+2/N]; nu=[0 0]; tf=1.7; p0=[be nu tf]; N1=N+1; 
optn=optimset('Display','Iter','MaxIter',1000);
p=fsolve('dgeot_f',p0,optn,th0,thf,phf);
[f,th,ph]=dgeot_f(p,th0,thf,phf); be=p([1:N]); beh=[be be(N)]/c;
tf=p(N+3); t=tf*[0:1/N:1]; th=th/c; ph=ph/c;
%
figure(1); clf; subplot(211),plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'ro',0,th(1),'ro',360-(139.7+145),70,'ro'); grid; axis([0 150 30 75]); 
text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); ylabel('Latitude \theta (deg)');
subplot(212), zohplot(ph,beh); grid;
ylabel('Heading Angle \beta (deg)'); xlabel('Longitude \phi (deg)'); 
	
