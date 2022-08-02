% Script p4_7_24n.m; 727 min time to climb to 2000 ft, V(0)=V(tf)=420 
% ft/sec, ga=0, using FOPTN;                               4/97, 9/5/02
%
W=180000; S=1560; rho=.002203; g=32.3; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
tc=sqrt(lc/g); name='mintalt'; 
al0=[.1761 .1494 .1301 .1160 .1060 .0991 .0949 .0931 .0932 .0950 ...
     .0983 .1028 .1083 .1143 .1205 .1268 .1326 .1378 .1420 .1451 ...
     .1469 .1472 .1461 .1435 .1395 .1343 .1280 .1211 .1139 .1067 ...
     .1001 .0943 .0897 .0866 .0854 .0861 .0889 .0941 .1017 .1122 .1258];
tf=5.6165; N=length(al0)-1; t=tf*[0:1/N:1]; s0=[420/Vc 0 0]';
nu=[-11.3775 -1.0126 -7.7676]; p0=[al0 nu tf]; 
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptn',p0,optn,name,s0); [f,s,la0]=foptn(p,name,s0);
al=p([1:41]); tf=p(45); V=s(1,:); ga=s(2,:); h=lc*s(3,:)/1000;
x=lc*cumtrapz(t,V.*cos(ga))/1000; V=Vc*V; t=tf*tc*[0:.025:1]; 
%
figure(1); clf; subplot(211), plot(x,h,[0 17.5],[.940 2.85],'r--',...
   [17.5 17.5],[2.85 2],'r--',[.1 .1],[0 .94],'r--'); grid 
axis([0 20 0 3]); xlabel('Horiz. Dist. (kft)') 
ylabel('Altitude (kft)'); subplot(212), plot(t,180*al/pi,[0 53],...
   [6.39 6.39],'r--'); grid; axis([0 60 0 10]); xlabel('Time (sec)')
ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h*1000,[342 342],[940 2850],'r--',[342 420],...
   [2850 2000],'r--',[342 420],[940 0],'r--'); grid 
axis([280 440 0 3000]); text(390,2700,'Zoom Dive') 
ylabel('Altitude (ft)'); text(350,250,'Zoom Climb')
text(350,1800,'Energy State'); text(302,2200,'Mass-Point')
xlabel('Velocity (ft/sec)') 	