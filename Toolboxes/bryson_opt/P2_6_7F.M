% Script p2_6_7f.m; VDP for min distance on a sphere using a penalty
% function with FOP0F;                                 3/97, 3/27/02
%
c=pi/180; th0=35.7*c; tf=2*pi-c*(139.7+73.8); 
s0=[0 th0]'; la0=[1 -.9053]; name='geot0'; p0=la0; 
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('fop0f',p0,optn,name,s0,tf);
[f,t,y]=fop0f(p,name,s0,tf); th=y(:,2)/c; N=length(t);
ph=t/c; be=-asin(y(:,4))/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph(N),th(N),'ro',0,th(1),...
   'ro',75,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude \theta (deg)'); text(5,35,'Tokyo');
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska');
subplot(212), plot(ph,be); grid; ylabel('Heading Angle \beta (deg)'); 
xlabel('Long. Diff. \phi-\phi_0 (deg)');
 



		