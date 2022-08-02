% Script p4_7_24b.m; 727 min time to climb to 2000 ft, V(0)=
% V(tf)=420 ft/sec, ga=0, using FOPTB;               4/97, 9/15/02
%
W=180000; S=1560; rho=.002203; g=32.3; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=sqrt(lc/g); tf=5.6404;
sf=[1.2977 0 .6167]; nu=[-11.3836 -1.0129 -7.7694];
s0=[420/Vc 0 0]'; name='mintalt'; p0=[sf nu tf];
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptb',p0,optn,name,s0);
[f,t,y]=foptb(p,name,s0); tf=p(7); N=length(t); un=ones(N,1);
V=y(:,1); ga=y(:,2); h=y(:,3); x1=cumtrapz(tf*un-t,V.*cos(ga));
lv=y(:,4); lg=y(:,5);
ao=.2476; a1=-.04312; a2=.008392; c=pi/180;
b1=-.08617; b2=1.996; c1=6.231; ep=2*c; al1=12*c; 
th=ao*ones(N,1)+a1*V+a2*V.^2; t=tc*t;  
al=(-b1*lv.*V.^2+lg.*(th./V+c1*V)-lv.*th*ep)./(lv.*(th+2*b2*V.^2));
V=Vc*V; h=lc*h/1000; x=lc*x1(N:-1:1)/1000;
%
figure(1); clf; subplot(211), plot(x,h); grid; axis([0 20 0 3]);
hold on; plot([0 17.5],[.940 2.85],'r--'); 
plot([17.5 17.5],[2.85 2],'r--',[.1 .1],[0 .94],'r--'); hold off
xlabel('Horizontal Distance (kft)'); ylabel('Altitude (kft)');
subplot(212), plot(t,al/c,t,al/c,'b.'); grid; hold on;
plot([0 53],[6.39 6.39],'r--'); hold off; axis([0 60 0 10]);
xlabel('Time (sec)'); ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h*1000); grid; hold on
plot([342 342],[940 2850],'r--',[342 420],[2850 2000],'r--');
plot([342 420],[940 0],'r--'); hold off; axis([280 440 0 3000]);
text(390,2700,'Zoom Dive'); text(350,250,'Zoom Climb');
text(350,1800,'Energy State'); text(302,2200,'Mass-Point');
xlabel('Velocity (ft/sec)'); ylabel('Altitude (ft)')
	