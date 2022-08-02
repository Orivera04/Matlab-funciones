% Script p3_1_03a.m; DVDP for min distance between two points on a
% sphere (Tokyo to New York); semi-analytic solution; approx. EOM;
% be(1) found off-line by interp. so that thf=40.7 deg=latitude
% of NY;                                            11/96, 3/26/02
%
c=pi/180; N=40; be(1)=63.945*c; th(1)=35.7*c; phf=-73.8*c;
pho=139.7*c; phf=2*pi-pho+phf; dph=phf/N;	
optn=optimset('MaxIter',100);
for i=1:N, be0=be(i); 
 th(i+1)=th(i)+tan(be0)*cos(th(i))*dph; th1=th(i+1);
 be(i+1)=fsolve('dgeo',be0,optn,be0,th1,dph);
end; ph=phf*[0:1/N:1]/c; be=be([1:N]); beh=[be be(N)]/c;
%
figure(1); clf; subplot(211), plot(ph,th/c,ph,th/c,'.',0,...
    th(1)/c,'ro',phf/c,th(N+1)/c,'ro',360-pho/c-145,70,'ro');
axis([0 150 30 75]); grid; ylabel('Latitude \theta (deg)');
text(5,35,'Tokyo'); text(120,42,'New York'); 
text(55,64,'Prudhoe Bay, Alaska'); subplot(212),
zohplot(ph,beh); grid; xlabel('Diff. Longitude \phi(deg)');
ylabel('Heading Angle \beta (deg)');
	


	
	
