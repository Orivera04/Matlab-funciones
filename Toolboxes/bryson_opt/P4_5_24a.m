% Script p4_5_24a.m; 727 min time to climb to 2000 ft, starting and
% ending w. V=420 ft/sec, ga=0, using FMINCON & ODEU; s=[V ga h]';  
%                                                            9/19/02
name='mintalt'; W=180000; S=1560; rho=.002203; g=32.3;
lc=2*W/(rho*g*S); Vc=sqrt(g*lc); tc=sqrt(lc/g); 
al0=[.1761 .1494 .1301 .1160 .1060 .0991 .0949 .0931 .0932 .0950 ...
     .0983 .1028 .1083 .1143 .1205 .1268 .1326 .1378 .1420 .1451 ...
     .1469 .1472 .1461 .1435 .1395 .1343 .1280 .1211 .1139 .1067 ...
     .1001 .0943 .0897 .0866 .0854 .0861 .0889 .0941 .1017 .1122 ...
     .1258]; N=length(al0); un=ones(1,N); tf=5.6165; p0=[al0 tf];
s0=[420/Vc 0 0]'; lb=[al0-.01*un 5.6]; ub=[al0+.01*un 5.7]; 
optn=optimset('Display','Iter','MaxIter',50);
p=fmincon('airc_f',p0,[],[],[],[],lb,ub,'airc_c',optn,s0,Vc,lc);
[c,ceq,s]=airc_c(p,s0,Vc,lc); V=Vc*s(1,:); ga=s(2,:); h=lc*s(3,:);
al=p(1:N); tf=p(N+1); t=tf*[0:1/(N-1):1];
x=lc*cumtrapz(t,s(1,:).*cos(ga)); t=t*tc;
%
figure(1); clf; subplot(211), plot(x,h,[0 17500],[940 2850],...
    'r--',[17500 17500],[2850 2000],'r--',[100 100],[0 940],'--'); 
grid; axis([0 20000 0 3000]); xlabel('Horiz. Dist. (ft)')
ylabel('Altitude (ft)'); subplot(212), plot(t,al*180/pi,[0 53],...
   [6.39 6.39],'r--'); grid; axis([0 60 0 10]) 
xlabel('Time (sec)'); ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h,[342 342],[940 2850],'r--',...
   [342 420],[2850 2000],'r--',[342 420],[940 0],'r--'); grid
axis([280 440 0 3000]); text(390,2700,'Zoom Dive') 
text(350,250,'Zoom Climb'); text(350,1800,'Energy State')
text(302,2200,'Mass-Point'); xlabel('Velocity (ft/sec)')
ylabel('Altitude (ft)')

% Convergence very slow if initial guess is only slightly off
% optimal!
	