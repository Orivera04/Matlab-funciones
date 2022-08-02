% Script p2_1_3a.m; DVDP for min distance to a meridian on a 
% sphere; semi-analytic solution; approx. EOM; th(0)=40 deg;
% phf=50 deg; be(1) found off-line by interpolation to give
% be(N)=0;                                        10/96, 3/26/02
%
N=40; c=pi/180; th(1)=40*c; phf=50*c; dph=phf/N; be(1)=36.576*c; 
optn=optimset('Display','Iter');
for i=1:N,  
 th(i+1)=th(i)+tan(be(i))*cos(th(i))*dph;  
 be(i+1)=fsolve('dgeo',be(i),optn,be(i),th(i+1),dph); end
ph=phf*[0:1/N:1]/c; th=th/c; be=be([1:N]); beh=[be be(N)]/c;
%
figure(1); clf; subplot(211),plot(ph,th,'.',ph,th); grid;
xlabel('Longitude \phi (deg)'); ylabel('Latitude \theta (deg)');
subplot(212), zohplot(ph,beh); xlabel('Longitude \phi (deg)');
grid; ylabel('Heading Angle \beta (deg)');
	
