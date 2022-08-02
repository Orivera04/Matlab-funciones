% Script p3_2_03a.m; DVDP for min distance between two points on a
% sphere using FMINCON; exact EOM;                       6/98, 3/13/02 
%
c=pi/180; th0=35.7*c; thf=c*40.7; phf=2*pi-c*(139.7+73.8);
optn=optimset('Display','Iter','MaxIter',450); be0=c*[50:-5:-40]; 
be=fmincon('dgeoc_f',be0,[],[],[],[],[],[],'dgeoc_c',optn,th0,thf,phf);
[f,th,s]=dgeoc_f(be,th0,thf,phf); N=length(be); N1=N+1; 
ph=phf*[0:1/N:1]/c; th=th/c; beh=[be be(N)]/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'ro',0,th(1),'ro',360-139.7-145,70,'ro'); axis([0 150 30 75]); 
grid; ylabel('Latitude \theta (deg)'); text(5,35,'Tokyo');
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska');
subplot(212), zohplot(ph,beh); grid; 
ylabel('Heading Angle \beta (deg)'); 
xlabel('Long. Diff. \phi-\phi_0 (deg)'); 	
	
