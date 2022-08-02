% Script p2_3_7.m; semi-analytic solution for min dist on a sphere
% (Tokyo to New York); p=[thm,al];                   8/97, 6/27/02
%
c=pi/180; th0=35.7*c; thf=40.7*c; tf=2*pi-c*(139.7+73.8);
p0=c*[70 -30]; optn=optimset('Display','Iter'); 
p=fsolve('geoa',p0,optn); un=ones(1,101); thm=p(1); al=p(2); 
ph=tf*[0:.01:1]; th=atan(tan(thm)*sin(ph-al*un));
be=acos(cos(thm)*un./cos(th));
for i=52:101, be(i)=-be(i); end
%
figure(1); clf; subplot(211), plot(ph/c,th/c,ph(1)/c,th(1)/c,...
   'ro',tf/c,thf/c,'ro',0,th0/c,'ro',360-139.7-145,70,'ro'); 
grid; axis([0 150 30 75]); ylabel('Latitude \theta (deg)')
text(10,35,'Tokyo'); text(125,40,'New York') 
text(60,64,'Prudhoe Bay,Alaska'); subplot(212), plot(ph/c,be/c);
grid; axis([0 150 -70 70]); ylabel('Heading \beta (deg)'); 
xlabel('Diff. Longitude \phi-\phi_0 (deg)');
