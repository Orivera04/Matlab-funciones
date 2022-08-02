% Script p2_1_3.m; min distance to a meridian on a sphere
% using FSOLVE with exact EL eqns; paths with N=5 & N=40; 
%                                           6/98, 3/30/02
%
c=pi/180; th0=c*40; phf=50*c; 
optn=optimset('Display','Iter','MaxIter',200);
be0=c*[40:-1:1]; be=fsolve('dgeo1',be0,optn,th0,phf);
[f,th,s]=dgeo1(be,th0,phf); N=length(be0);
ph=phf*[0:1/N:1]/c; th=th/c; beh=[be be(N)]/c;
be01=c*[32:-7:4]; be1=fsolve('dgeo1',be01,optn,[],th0,phf);
[f,th1,s1]=dgeo1(be1,th0,phf); N1=length(be01);
ph1=phf*[0:1/N1:1]/c; th1=th1/c; be1h=[be1 be1(N1)]/c;
%
figure(1); clf; subplot(211), plot(ph,th,'b',ph1,th1,'r--');
grid; hold on; legend('N=40','N=5',2); plot(ph,th,'b.',...
    ph1,th1,'rs'); hold off; xlabel('Long. \phi (deg)') 
ylabel('Lat. \theta (deg)'); subplot(212), zohplot(ph,beh,'b'); 
hold on; zohplot(ph1,be1h,'r--'); grid; legend('N=40','N=5')
hold off; xlabel('Longitude \phi (deg)')
ylabel('Heading Angle \beta (deg)')
	
	