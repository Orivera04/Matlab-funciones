% Script p4_7_18f.m; TDP for min time trsfr to Venus orbit using FOPTF;
% y=[r u v th lr lu lv lt]'; be=thrust direction angle;   4/97, 3/28/02
%
clear; clear global; global rf; rf=.7233; la0=[6.5785 3.6727 5.3864 0];
tf=2.3957; c=180/pi; nu=[7.8377 -2.1726  5.4222]; p0=[la0 nu tf];
optn=optimset('Display','Iter','MaxIter',150);
name='mart'; s0=[1 0 1 0]'; p=fsolve('foptf',p0,optn,name,s0);
[f,t,y]=foptf(p,name,s0); N=length(t); be=atan2(y(:,6),y(:,7));
for i=1:N, if be(i)<0, be(i)=be(i)+2*pi; end; end;
xc=y(:,1).*cos(y(:,4)); yc=y(:,1).*sin(y(:,4));
xt=xc+.2*sin(be-y(:,4)); yt=yc+.2*cos(be-y(:,4)); th=2*pi*[0:.02:1]';
xe=cos(th); ye=sin(th); xv=.7233*cos(th); yv=.7233*sin(th); 
%
figure(1); clf; plot(xe,ye,'r--',xv,yv,'r--'); hold on; 
plot(xc,yc,0,0,'ro',1,0,'ro',xc(N),yc(N),'ro');
for i=1:N, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.04,'r','-'); end;
hold off; grid; axis([-1.1 1.1 -.6 1.6]); axis('square') 
xlabel('x/ro'); ylabel('y/ro'); text(-.35,.5,'VENUS ORBIT'); 
text(-.95,.9,'EARTH ORBIT'); text(-.18,.1,'SUN')
%
figure(2); clf; plot(t,y(:,[1:3])); grid; xlabel('Time'); 
text(2.2,1.3,'v'); text(2.2,.9,'r'); text(2.2,.3,'u');
%
figure(3); clf; plot(t,c*be); grid; ylabel('\beta (deg)');
xlabel('Time'); 
%
figure(4); clf; plot(t,y(:,[5:7])); grid; xlabel('Time');
text(1.7,6.2,'\lambda_r'); text(1.7,-1,'\lambda_u');
text(1.7,2.8,'\lambda_v');
	  

	

 

