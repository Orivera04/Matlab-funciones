% Script p3_4_03.m; min distance on a sphere (Tokyo to New York); 
%                                                          11/96, 7/16/02
%
clear; clear global; global thf; c=pi/180; thf=40.7*c; name='geoc';
ph0=139.7*c; phf=-73.8*c; N=40; s0=[0 35.7*c]'; tf=2*pi+phf-ph0;
be0=[1.1348  1.0949  1.0504  1.0026  0.9521  .8996  .8455 0.7902 0.7338...
     0.6766  0.6188  0.5604  0.5016  0.4425  .3832  .3237 0.2641 0.2044...
     0.1446  0.0849  0.0251  -.0346  -.0944 -.1541 -.2138 -.2734 -.3330...
     -.3924  -.4517 -0.5107  -.5695  -.6278 -.6855 -.7426 -.7988 -.8540...
     -.9079  -.9601 -1.0102 -1.0576 -1.1014]';
%u0=[1:-2/N:-1]; 
tu=tf*[0:1/N:1]'; k=.3; told=1e-5; tols=5e-4; mxit=20; 
[t,be,s,nu,la0]=fopc(name,tu,be0,tf,s0,k,told,tols,mxit);
be=be/c; ph=t/c; d=s(:,1); th=s(:,2)/c; N1=length(ph); 
%
figure(1); clf; subplot(211), plot(ph,th,ph(N1),th(N1),'ro',0,th(1),...
   'ro',360-ph0/c-145,70,'ro'); grid; axis([0 150 30 75]) 
ylabel('Latitude (deg)'); text(5,35,'Tokyo'); text(120,42,'New York')
text(55,64,'Prudhoe Bay, Alaska'); subplot(212), plot(ph,be); grid
ylabel('Heading Angle \beta (deg)') 
xlabel('Long. Diff. \phi-\phi_0 (deg)')
 
	


		
	
