% Script p3_4_11.m; VDP for max range with gravity, thrust,  
% & spec. yf; s=[V y x]';                      2/97, 6/16/02
%
clear; clear global; global a yf; a=.5; yf=.1; name='vdpct'; 
N=20; ga0=(pi/2)*[-1:2/N:1]'; tf=1; tu=[0:1/N:1]'; 
s0=[0 0 0]'; k=-1; told=1e-5; tols=3e-4; mxit=50; 
[t,ga,s]=fopc(name,tu,ga0,tf,s0,k,told,tols,mxit);
V=s(:,1); y=s(:,2); x=s(:,3); N1=length(t); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
ylabel('y/gt_f^2'); xlabel('x/gt_f^2'); axis([0 .35 -.2 .15])
axis('square')
%
figure(2); clf; subplot(211), plot(t,V); grid; ylabel('V')
axis tight; subplot(212), plot(t,ga*180/pi); grid
xlabel('Time'); axis tight; ylabel('\gamma (deg)')
	