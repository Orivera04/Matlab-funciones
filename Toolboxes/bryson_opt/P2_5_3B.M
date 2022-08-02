% Script p2_5_3b.m; disc. geod. Pb using DOP0B; min dist. to a 
% meridian on a sphere; th(0)=40 deg; phf=50 deg; 3/97, 3/28/02
%
N=40; uf=.0087; sf=[.6271 .9164]'; c=pi/180; s0=[0 c*40]';
tf=c*50; name='dgeo0'; 
optn=optimset('Display','Iter','MaxIter',50); 
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u,la]=dop0b(sf,name,uf,s0,tf,N); d=s(1,:); th=s(2,:)/c;
ph=tf*[0:1/N:1]/c;
% 
figure(1); clf; plot(ph,th,'.',ph,th); grid; axis([0 50 40 54])
xlabel('Long. (deg)'); ylabel('Lat. (deg)')
	
	
