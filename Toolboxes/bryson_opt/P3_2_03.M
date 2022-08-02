% Script p3_2_03.m; DVDP for min distance between points on a sphere
% (Tokyo to New York);                                  8/97, 3/26/02
%
N=40; be=[1:-2/N:-1+2/N]; c=pi/180; pho=139.7*c; phf=-73.8*c;
s0=[0 35.7*c]'; tf=2*pi+phf-pho; k=10; tol=1e-4; mxit=50; 
[be,s,nu,la0]=dopc('dgeoc',be,s0,tf,k,tol,mxit);
beh=[be be(N)]/c; th=s(2,:)/c; ph=tf*[0:1/N:1]/c; N1=N+1;
% 
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'o',0,th(1),'o',360-pho/c-145,70,'o'); grid; axis([0 150 30 75]); 
ylabel('Latitude (deg)'); text(5,35,'Tokyo'); text(120,42,'New York');
text(55,64,'Prudhoe Bay, Alaska'); subplot(212), 
zohplot(ph,beh); grid; ylabel('Heading Angle \beta (deg)');
xlabel('Long. Diff. \phi-\phi_0 (deg)'); 	
	
