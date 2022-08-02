% Script p4_5_24.m; 727 min time to climb to 2000 ft, starting and
% ending with V=420 ft/sec, gamma=0;                 2/97, 9/15/02
%
clear; name='mintalt'; W=180000; S=1560; rho=.002203; g=32.3;
lc=2*W/(rho*g*S); Vc=sqrt(g*lc); tc=sqrt(lc/g); 
al0=[.1699  .1465  .1285  .1152  .1057  .0992  .0952...
  	 .0935  .0937  .0955  .0987  .1030  .1080  .1136...
  	 .1193  .1249  .1301  .1348  .1387  .1416  .1433...
  	 .1438  .1428  .1406  .1370  .1323  .1266  .1203...
  	 .1136  .1068  .1004  .0947  .0901  .0869  .0853...
  	 .0856  .0881  .0929  .1002  .1102  .1231]';
tf=5.6; N=length(al0)-1; tu=tf*[0:1/N:1]; mxit=50;
s0=[420/Vc 0 0]'; k=1e-5; told=1e-4; tols=1e-4; 
[t,al,s,tf,nu,la0]=fopt(name,tu,al0,tf,s0,k,told,tols,mxit);
ga=s(:,2); x=lc*cumtrapz(t,s(:,1).*cos(ga))/1000; h=lc*s(:,3)/1000;
V=Vc*s(:,1); al=al*180/pi; t=tc*t;
%
figure(1); clf; subplot(211), plot(x,h,[0 17.5],[.940 2.85],...
    'r--',[17.5 17.5],[2.85 2],'r--',[.1 .1],[0 .94],'--'); 
grid; axis([0 20 0 3]); xlabel('Horiz. Dist. (kft)');
ylabel('Altitude (kft)'); subplot(212), plot(t,al,[0 53],...
   [6.39 6.39],'r--'); grid; axis([0 60 0 10]); 
xlabel('Time (sec)'); ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h*1000,[342 342],[940 2850],'r--',...
   [342 420],[2850 2000],'r--',[342 420],[940 0],'r--'); grid
axis([280 440 0 3000]); text(390,2700,'Zoom Dive') 
text(350,250,'Zoom Climb'); text(350,1800,'Energy State')
text(302,2200,'Mass-Point'); xlabel('Velocity (ft/sec)')
ylabel('Altitude (ft)')
	