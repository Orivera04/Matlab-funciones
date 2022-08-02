% Script latturn.m; max cross-range for entry glider; Vinh (1981)
% and Josselyn & Ross (9/02); s=[r th ph v ps ga]'; u=[de al]';
%                                                         9/13/02
%
r0=2.0903e7; z=pi/180; s0=[r0+2.6e5 0 0 2.56e4 0 -z*1]'; tf=2300;
N=21; de=z*[-120:6:0]; al=z*17.5*ones(1,N); p=[de al tf];
optn=optimset('Display','Iter','MaxIter',0);
%p=fmincon('latturn_f',p0,[],[],[],[],[],[],'latturn_c',optn,s0,r0);
[f,s]=latturn_f(p,s0,r0); 
h=(s(1,:)-r0)/1e5; th=s(2,:)/z; ph=s(3,:)/z; v=s(4,:)/1e3;
ps=s(5,:)/z; ga=s(6,:)/z; de=p(1:N)/z; al=p(N+1:2*N)/z; 
tf=p(2*N+1); t=tf*[0:.05:1];
%
figure(1); clf; subplot(321), plot(t,h); grid
ylabel('Altitude (100kft)'); subplot(322), plot(t,v); grid
ylabel('Velocity (kft/sec)'); subplot(323), plot(t,th); grid
ylabel('Longitude (deg)'); subplot(324), plot(t,ps); grid
ylabel('Heading Angle (deg)'); subplot(325), plot(t,ph); grid
ylabel('Latitude (deg)'); xlabel('Time (sec)'); subplot(326)
plot(t,ga); grid; ylabel('Flight Path Angle (deg)')
xlabel('Time (sec)')
%
figure(2); clf; subplot(211), plot(t,de); grid
ylabel('Bank Angle (deg)'); subplot(212), plot(t,al); grid
ylabel('Angle of Attack (deg)'); xlabel('Time (sec)')
