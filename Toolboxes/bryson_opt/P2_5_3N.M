% Script p2_5_3n.m; min dist. to a meridian on a sphere using DOP0N;
% th(0)=40 deg; phf=50 deg;                            4/97, 3/28/02
%
%u0=.2*ones(1,40);
u0=[.638 .624 .609 .594 .580 .565 .549 .534 .519 .503 ...
    .487 .471 .455 .439 .423 .407 .390 .374 .357 .341 ...
    .324 .307 .291 .274 .257 .240 .223 .206 .189 .172 ...
    .155 .137 .120 .103 .086 .069 .051 .034 .017 .002];
N=length(u0); c=pi/180; s0=[0 c*40]'; tf=c*50; name='dgeo0';
optn=optimset('Display','Iter','MaxIter',500); N1=N+1; 
u=fsolve('dop0n',u0,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); uh=[u u(N)]/c;
d=s(1,:); th=s(2,:)/c; ph=tf*[0:1/N:1]/c;
% 
figure(1); clf;subplot(211),plot(ph,th,'.',ph,th,ph(N1),th(N1),'o');
grid; axis([0 50 40 54]); ylabel('Latitude \theta(deg)'); 
subplot(212), zohplot(ph,uh); grid; ylabel('Heading Angle \beta (deg)');
xlabel('Longitude \phi (deg)');
	
	
