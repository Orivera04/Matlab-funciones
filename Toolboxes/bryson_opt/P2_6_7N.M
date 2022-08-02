% Script p2_6_7n.m; min distance on a sphere using a penalty 
% function and FOP0N;                                2/97, 8/16/02
%
clear; clear global; global Sf thf; Sf=50; c=pi/180; N=20; N1=21;
thf=40.7*c;th0=35.7*c; s0=[0 th0]'; tf=2*pi-c*(139.7+73.8); 
be0=[1.143 1.058 .960 .853 .741 .626 .509 .390 .271 .151 .030 ...
   -.090 -.210 -.330 -.449 -.567 -.683 -.797 -.906 -1.010 -1.102]; 
name='geot0'; optn=optimset('Display','Iter','MaxIter',500);
be=fsolve('fop0n',be0,optn,name,s0,tf); 
[f,s,la0]=fop0n(be,name,s0,tf); th=s(2,:)/c; ph=(tf*[0:N]/N)/c;
%
figure(1); clf; subplot(211), plot(ph,th,ph(N1),th(N1),'ro',...
    0,th(1),'ro',76,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude \theta (deg)'); text(5,35,'Tokyo');
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska');
subplot(212), plot(ph,be/c); ylabel('Heading Angle \beta (deg)'); 
grid; xlabel('Long. Diff. \phi-\phi_0 (deg)');
 

	
