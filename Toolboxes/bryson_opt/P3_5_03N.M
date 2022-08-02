% Script p3_5_03n.m; DVDP for min distance between 2 points on a sphere
% (Tokyo to New York);                                    5/97, 5/27/02
%
N=40; c=pi/180; pho=139.7*c; phf=-73.8*c; N1=N+1;  
p0=[1.1156  1.0733  1.0271  0.9779  0.9264  0.8731  0.8184...
  	0.7626  0.7059  0.6485  0.5905  0.5320  0.4732  0.4140...
  	0.3546  0.2950  0.2353  0.1754  0.1154  0.0554 -0.0047...
   -0.0647 -0.1248 -0.1847 -0.2446 -0.3043 -0.3639 -0.4233...
   -0.4824 -0.5412 -0.5995 -0.6575 -0.7148 -0.7713 -0.8270...
   -0.8815 -0.9345 -0.9857 -1.0345 -1.0802  0.8919];
be0=[1:-2/N:-1+2/N]; nu=.8277; p0=[be0 nu]; name='dgeoc';
s0=[0 35.7*c]'; tf=2*pi+phf-pho; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); be=p([1:N]); nu=p(N+1);
beh=[be be(N)]/c; th=s(2,:)/c; ph=tf*[0:1/N:1]/c;
% 
figure(1); clf; subplot(211), plot(ph,th,ph,th,'.',ph(N1),th(N1),...
   'ro',0,th(1),'ro',360-pho/c-145,70,'ro'); grid;
axis([0 150 30 75]); text(5,35,'Tokyo'); text(120,42,'New York'); 
text(55,64,'Prudhoe Bay, Alaska'); ylabel('Lat. \theta (deg)');
subplot(212), zohplot(ph,beh); grid; ylabel('Heading (deg)');
xlabel('Long. Diff. \phi-\phi_0 (deg)'); 	
	
