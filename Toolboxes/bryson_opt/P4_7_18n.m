% Script p4_7_18n.m; TDP for min time trsfr to Venus orbit using FOPTN;
% s=[r u v th]'; be=thrust direction angle;               2/97, 3/28/02
%
global rf; rf=.7233; nu=[7.838 -2.173  5.422]; tf=2.396; 
be0=[-2.543 -2.504 -2.463 -2.420 -2.375 -2.327 -2.275 -2.220 -2.160 ...
     -2.096 -2.024 -1.945 -1.856 -1.751 -1.618 -1.390  0.008  1.410 ...
     1.652 1.808 1.939 2.058 2.167 2.268 2.360  2.445  2.521  2.590 ...
     2.653  2.710 2.760]; p0=[be0 nu tf]; 
optn=optimset('Display','Iter','MaxIter',150);
name='mart'; s0=[1 0 1 0]'; p=fsolve('foptn',p0,optn,name,s0);
[f,s,la0]=foptn(p,name,s0); be=p([1:31]); tf=p(35);
xc=s(1,:).*cos(s(4,:)); yc=s(1,:).*sin(s(4,:));
xt=xc+.35*sin(be-s(4,:)); yt=yc+.35*cos(be-s(4,:)); 
th=2*pi*[0:.02:1]'; xe=cos(th); ye=sin(th); N=length(xc);
xv=.7233*cos(th); yv=.7233*sin(th); t=tf*[0:1/(N-1):1];
%
figure(1); clf; plot(xe,ye,'r--',xv,yv,'r--'); hold on 
plot(xc,yc,0,0,'ro',1,0,'ro',xc(N),yc(N),'ro');
for i=1:N, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.04,'r','-'); end
hold off; grid; axis([-1.1 1.1 -1 1.2]); axis('square') 
xlabel('x/ro'); ylabel('y/ro'); text(-.35,.5,'VENUS ORBIT') 
text(-.95,.9,'EARTH ORBIT'); text(-.18,.1,'SUN')
