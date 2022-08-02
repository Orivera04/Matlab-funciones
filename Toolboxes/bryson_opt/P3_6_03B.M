% Script p3_6_03b.m; VDP for min distance to a point on a sphere using
% FOPCB;                                                 6/97, 5/28/02
%
clear; clear global; global thf; c=pi/180; thf=c*40.7; pho=139.7*c;
phf=-73.9*c; nu=.8919 ; s0=[0 35.7*c]'; sf=[1.7035 .7103]; name='geoc';
optn=optimset('Display','Iter','MaxIter',15);
tf=2*pi+phf-pho; p0=[sf nu]; p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf);d=y(:,1); th=y(:,2)/c; lth=y(:,4);
[N,n1]=size(y); ph=t/c; be=-asin(lth)/c; 
%
figure(1); clf; subplot(211), plot(ph,th,ph(1),th(1),'ro',0,th(N),...
   'ro',360-pho/c-145,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude (deg)'); text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); subplot(212), plot(ph,be); grid;
ylabel('Heading Angle \beta (deg)');
xlabel('Long. Diff. \phi-\phi_0 (deg)');
 


