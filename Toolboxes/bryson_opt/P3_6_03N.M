% Script p3_6_03n.m; min distance between 2 points on a sphere (Tokyo to
% New York); tho=35.7 deg, pho=139.7 deg, thf=40.7 deg, phf=-73.8 deg;
%                                                          4/97, 5/28/02
%
clear; clear global; global thf; c=pi/180; thf=40.7*c; pho=139.7*c;
phf=-73.8*c; N=40; s0=[0 35.7*c]'; tf=2*pi+phf-pho; % u0=[1:-2/N:-1]; 
u0=[1.1348  1.0949  1.0504  1.0026  .9521  .8996  .8455...
  	  .7902  0.7338  0.6766  0.6188  .5604  .5016  .4425...
     .3832  0.3237  0.2641  0.2044  .1446  .0849  .0251...
    -.0346 -0.0944 -0.1541 -0.2138 -.2734 -.3330 -.3924...
    -.4517 -0.5107 -0.5695 -0.6278 -.6855 -.7426 -.7988...
    -.8540 -0.9079 -0.9601 -1.0102 -1.0576 -1.1014];
nu=.8919; name='geoc'; p0=[u0 nu];
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcn',p0,optn,name,s0,tf); N1=N+1;
[f,s,be,la0]=fopcn(p,name,s0,tf); d=s(1,:); th=s(2,:)/c; 
ph=tf*[0:1/N:1]/c; be=be/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph(N1),th(N1),'ro',0,th(1),...
   'ro',360-pho/c-145,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude (deg)'); text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); subplot(212), plot(ph,be); grid;
ylabel('Heading Angle \beta (deg)');
xlabel('Long. Diff. \phi-\phi_0 (deg)');


	
