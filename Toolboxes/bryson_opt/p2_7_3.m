% Script p2_7_3.m; numerical solution for min dist on a sphere
% (Tokyo to New York) using FOP0; s=[d th]'; indpt variable is
% longitude difference;                                 7/3/02
%
global thf sth; c=pi/180; thf=40.7*c; sth=1e4;
load p2_7_3; tu=ph'; be0=be'; name='geo0y';
th0=35.7*c;                                 % Initial latitude
tf=2*pi-c*(139.7+73.8);           % Final longitude difference
s0=[0 th0]'; k=4e-6; told=1e-5; tols=told; mxit=20;
[t,be,s]=fop0(name,tu,be0,tf,s0,k,told,tols,mxit);
ph=t/c; th=s(:,2)/c; be=be/c; 
%
figure(1); clf; subplot(211), plot(ph,th,ph(1),th(1),...
   'ro',tf/c,thf/c,'ro',0,th0/c,'ro',360-139.7-145,70,'ro'); 
grid; axis([0 150 30 75]); ylabel('Latitude \theta (deg)')
text(10,35,'Tokyo'); text(125,42,'New York') 
text(60,64,'Prudhoe Bay,Alaska'); subplot(212), plot(ph,be);
grid; axis([0 150 -70 70]); ylabel('Heading \beta (deg)') 
xlabel('Diff. Longitude \phi-\phi_0 (deg)')
