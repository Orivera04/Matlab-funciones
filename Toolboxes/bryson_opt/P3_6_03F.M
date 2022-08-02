% Script p3_6_03f.m; VDP for min distance to a point on a sphere using
% FOPCF;                                                 2/97, 5/28/02
%
clear; clear global; global thf; c=pi/180; thf=c*40.7; pho=139.7*c;
phf=-73.9*c; la0=[1 -.9065]; nu=.8919 ; s0=[0 35.7*c]'; name='geoc';
optn=optimset('Display','Iter','MaxIter',15);
tf=2*pi+phf-pho; p0=[la0 nu];
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); d=y(:,1); th=y(:,2)/c;
lth=y(:,4); [N,n1]=size(y); ph=t/c; be=-asin(lth)/c; 
%
figure(1); clf; subplot(211), plot(ph,th,ph(N),th(N),'ro',0,th(1),...
   'ro',360-pho/c-145,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude (deg)'); text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); subplot(212), plot(ph,be); grid;
ylabel('Heading Angle \beta (deg)');
xlabel('Long. Diff. \phi-\phi_0 (deg)');



	