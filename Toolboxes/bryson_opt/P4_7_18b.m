% Script p4_7_18b.m; TDP for min time trsfr to Venus orbit using FOPTB;
% y=[r u v th lr lu lv lt]'; be=thrust direction angle; 4/97, 3/28/02
%
clear; clear global; global rf; rf=.7233; sf=[.7233 0 1.1758 3.0558];
nu=[7.8377 -2.1726 5.4222]; tf=2.3957; c=180/pi; p0=[sf nu tf];
optn=optimset('Display','Iter','MaxIter',50); name='mart'; 
s0=[1 0 1 0]'; p=fsolve('foptb',p0,optn,name,s0);
[f,t,y]=foptb(p,name,s0); N=length(t); be=atan2(y(:,6),y(:,7));
for i=1:N, if be(i)<0, be(i)=be(i)+2*pi; end; end;
xc=y(:,1).*cos(y(:,4)); yc=y(:,1).*sin(y(:,4));
xt=xc+.2*sin(be-y(:,4)); yt=yc+.25*cos(be-y(:,4)); th=2*pi*[0:.02:1]';
xe=cos(th); ye=sin(th); xv=.7233*cos(th); yv=.7233*sin(th);
r=y(:,1); u=y(:,2); v=y(:,3); th=y(:,4);
th1=[0:6:360]*pi/180; xj=5.2*cos(th1);
yj=5.2*sin(th1); xe=cos(th1); ye=sin(th1); lr=y(:,5); lu=y(:,6);
lv=y(:,7);
%
figure(1); clf; plot(xe,ye,'r--',xv,yv,'r--'); hold on 
plot(xc,yc,0,0,'ro',1,0,'ro',xc(1),yc(1),'ro');
for i=1:N, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.06,'r','-'); end
hold off; grid; axis([-1.1 1.1 -.7 1.5]); axis('square') 
xlabel('x/r_o'); ylabel('y/r_o'); text(-.35,.5,'VENUS ORBIT') 
text(-.95,.9,'EARTH ORBIT'); text(-.18,.1,'SUN')
%
figure(2); clf; subplot(311), plot(t,r,t,u,'r--',t,v,'k-.'); grid
legend('r','u','v'); axis tight; subplot(312), plot(t,c*be); grid 
ylabel('\beta (deg)'); axis tight; subplot(313),plot(t,lr,t,...
    lu,'r--',t,lv,'k-.'); axis tight; grid; xlabel('Time')
legend('\lambda_r','\lambda_u','\lambda_v')
