% Script p2_4_7.m; min dist on sphere using quad. penalty on terminal
% latitude error;                                 8/97, 6/98, 3/13/02
%
clear; clear global; global Sf thf; Sf=50; c=pi/180; thf=40.7*c;
name='geot0'; th0=35.7*c; s0=[0 th0]'; tf=2*pi-c*(139.7+73.8); k=.0007;
told=1e-4; tols=1e-4; mxit=50; N=20; tu=tf*[0:1/N:1]'; %u=[1:-2/N:-1]';
u=[1.143 1.058 .960 .853 .741 .626 .509 .390 .271 .151 .030 ...
   -.090 -.210 -.330 -.449 -.567 -.683 -.797 -.906 -1.010 -1.102]'; 
[t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);
pht=t/c; th=s(:,2)/c; phb=u/c; be=u/c;
%
figure(1); clf; subplot(211), plot(pht,th,tf/c,thf/c,'ro',0,th(1),...
   'ro',76,70,'ro'); grid; axis([0 150 30 75]); 
ylabel('Latitude \theta (deg)'); text(5,35,'Tokyo');
text(120,42,'New York'); text(55,64,'Prudhoe Bay, Alaska');
subplot(212), plot(phb,be); grid; ylabel('Heading Angle \beta (deg)'); 
xlabel('Long. Diff. \phi-\phi_0 (deg)');
 
 % NOTE this code converges to an inaccurate path from the rough initial
 % guess of u; however, if the converged 'u' from p2_6_7 is used as 
 % the initial guess it verifies that this path has a near-zero 
 % gradient.


