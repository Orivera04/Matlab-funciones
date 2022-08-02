% Script p4_7_17b.m; TDP for min time trsfr to Jupiter orbit using FOPTB;
% y=[r u v th lr lu lv lt]'; be=thrust direction angle; 6/97, 3/28/02
%
clear; clear global; global rf; rf=5.2; sf=[5.20 0 .4387  3.2614];
nu=[-.813 2.630 -.761]; tf=8.216; c=180/pi; p0=[sf nu tf];
optn=optimset('Display','Iter','MaxIter',100); name='mart';
s0=[1 0 1 0]'; 
load p4_7_17b; p0=p;
p=fsolve('foptb',p0,optn,name,s0); 
[f,t,y]=foptb(p,name,s0); N=length(t); be=atan2(-y(:,6),-y(:,7));       
for i=1:N, if be(i)<-.2, be(i)=be(i)+2*pi; end; end;
r=y(:,1); u=y(:,2); v=y(:,3); th=y(:,4); xc=r.*cos(th);yc=r.*sin(th);
yt=yc+.75*cos(be-th); th1=[0:6:360]*pi/180; xj=5.2*cos(th1);
yj=5.2*sin(th1); xe=cos(th1); ye=sin(th1); lr=y(:,5); lu=y(:,6);
lv=y(:,7);
%
figure(1); clf; plot(xc,yc); grid; hold on; xt=xc+.75*sin(be-th);
plot(xe,ye,'r--',1,0,'ro',xc(1),yc(1),'ro'); for i=1:2:N,
   pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.15,'r','-'); end;
plot(xj,yj,'r--',0,0,'ro'); hold off; axis([-6 1 -.75*3 .75*4]);
xlabel('x/ro'); ylabel('y/ro'); text(-2.5,-.8,'EARTH ORBIT'); 
text(-4.8,1.2,'JUPITER ORBIT'); text(-.5,.5,'SUN'); 
%
figure(2); clf; subplot(311), plot(t,r,t,u,'r--',t,v,'k-.'); grid;
legend('r','u','v'); axis tight; subplot(312), plot(t,c*be); grid; 
ylabel('\beta (deg)'); axis tight; subplot(313),plot(t,lr,t,...
    lu,'r--',t,lv,'k-.'); axis tight; grid; xlabel('Time');
legend('\lambda_r','\lambda_u','\lambda_v');
