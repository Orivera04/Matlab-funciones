% Script p3_3_03.m; min distance to a point on a sphere (Tokyo to
% New York); from analytical solution where ph0=0; 12/96, 7/16/02
%
c=pi/180; th0=35.7*c; thf=40.7*c; phf=146.5*c; 
phm=atan((tan(th0)*cos(phf)-tan(thf))/(-tan(th0)*sin(phf)));
thm=atan(tan(th0)/cos(phm)); ph=phf*[0:.01:1]; un=ones(1,101);
th=atan(tan(thm)*cos(phm*un-ph));
be=acos(un*cos(thm)./cos(th)).*sign(un*phm-ph);
ph=ph/c; th=th/c; be=be/c; th0=th0/c; phf=phf/c; thf=thf/c;
 %
figure(1); clf; subplot(211), plot(ph,th,0,th0,'ro',phf,...
   thf,'ro',75.3,70,'ro',74.80,69.95,'bo'); grid
axis([0 phf 30 75]); ylabel('Latitude (deg)'); text(5,35,'Tokyo')
text(125,42,'New York'); text(60,64,'Prudhoe Bay,Alaska')
subplot(212); plot(ph,be); grid; ylabel('Heading (deg)')
axis([0 phf -70 70]); xlabel('Diff. Longitude(deg)') 
	
	
	
