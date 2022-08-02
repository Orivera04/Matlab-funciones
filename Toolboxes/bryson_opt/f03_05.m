% Script f3_05.m; DVDP for max range with gravity, thrust, 
% and spec. yf; t in tf, V in a*tf, (x,y) in a*tf^2, g in a;
% s=[V y x]'; ga=ctrl;                         2/94, 3/31/02  
%
clear; clear global; global a yf; a=.5; yf=.1; 
ga0=(pi/2)*[-1:.05:.6]; k=-35; mxit=10; s0=[0 0 0]'; tf=1; 
tol=1e-5; c=180/pi;
[ga,s]=dopc('dvdpct',ga0,s0,tf,k,tol,mxit); N=length(ga);
V=s(1,:); t=tf*[0:1/N:1]; N1=N+1; x=s(2,:); y=s(3,:);
gah=[ga ga(N)]*c;
%
figure(1); clf; plot(x,y,x,y,'b.',x(N1),y(N1),'ro',0,0,...
   'ro',0,.15,'ro',0,-.12,'ro'); grid; axis([0 .27 -.12 .15]); 
axis('square'); axis([0 .35 -.2 .15]); xlabel('x/gt_f^2'); 
ylabel('y/gt_f^2');
%
figure(2); clf; subplot(211), plot(t,V); grid; ylabel('V');
subplot(212), zohplot(t,gah); grid; ylabel('\gamma (deg)');
xlabel('t/t_f'); 

