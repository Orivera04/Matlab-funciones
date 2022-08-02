% Script p3_5_03b.m; DVDP for min distance between 2 points on a sphere
% (Tokyo to New York); tho=35.7 deg, pho=139.7 deg, thf=40.7 deg,
% phf=-73.8 deg;                                          2/98, 5/27/02  
%
N=40; c=pi/180; pho=139.7*c; phf=-73.8*c; name='dgeoc'; s0=[0 35.7*c]';
tf=2*pi+phf-pho; nu=.8919; sf=[1.7043 .7103]; p0=[sf nu]; uf=-1.0802;
optn=optimset('Display','Iter','MaxIter',500); N1=N+1;
p=fsolve('dopcb',p0,optn,name,uf,s0,tf,N);
[f,s,u]=dopcb(p,name,uf,s0,tf,N); beh=[u u(N)]/c;
th=s(2,:)/c; ph=tf*[0:1/N:1]/c;
% 
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',ph(N1),th(N1),'ro');
grid; hold on; plot(0,th(1),'ro',360-pho/c-145,70,'ro',0,th(1),'ro');
hold off;  axis([0 150 30 75]); text(5,35,'Tokyo')
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska')
ylabel('Lat. (deg)'); subplot(212), zohplot(ph,beh); grid
xlabel('Long. Diff. (deg)'); ylabel('Heading (deg)')
	
	
