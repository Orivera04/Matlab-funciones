% Script p1_2_15.m; plots of min weight cantilever truss from 
% analytical solution;                             5/98, 6/27/02
% 
% For slender column (z>1):
rz=[.01:.01:.09 .1:.02:1]; N=length(rz); un=ones(1,N); z=un./rz; 
W=sqrt(un+z)./(2*z.^2); th=atan(sqrt(un+z)); c=180/pi;
J=un./z+W./(sin(th).*cos(th)); Wc=1/sqrt(2); thc=atan(sqrt(2));
%
% For short column (z<1):
W1=[Wc .74 .76 .78 .8:.1:1.5]; N1=length(W1); un1=ones(1,N1);
th1=atan(un1*sqrt(2)); z1=2*un1./(sqrt(2)*W1+un1);
J1=un1/2+2*sqrt(2)*W1; Jc=2.5;
%
figure(1); clf; subplot(211); plot(W,c*th,'b',W,15*J,'r--',...
   W1,c*th1,'b',W1,15*J1,'r--',Wc,c*thc,'o',Wc,15*Jc,'o',0,...
   90,'bo',0,0,'ro'); grid; axis([0 1.5 0 90])
ylabel('th (deg) & 15*J'); subplot(212)
plot(W,un./z,'b',W1,un1./z1,'b',Wc,1,'o',0,0,'bo'); grid
axis([0 1.5 0 2]); ylabel('1/z'); xlabel('W')