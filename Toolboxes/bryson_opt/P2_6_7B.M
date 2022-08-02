% Script p2_6_7b.m; VDP for min distance on a sphere using a penalty
% function with FOP0B; 	                               3/97, 3/27/02
%
c=pi/180; th0=35.7*c;  tf=2*pi-c*(139.7+73.8); 
sf=[1.6542 .7282]'; s0=[0 th0]'; name='geot0'; p0=sf; 
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('fop0b',p0,optn,name,s0,tf);
[f,t,y]=fop0b(p,name,s0,tf); th=y(:,2)/c; N=length(t); ph=t/c;
be=-asin(y(:,4))/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph(1),th(1),'ro',0,...
    th(N),'ro',75,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude \theta (deg)'); text(5,35,'Tokyo')
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska')
subplot(212), plot(ph,be); ylabel('Heading Angle \beta (deg)') 
grid; xlabel('Long. Diff. \phi-\phi_0 (deg)');
 


		