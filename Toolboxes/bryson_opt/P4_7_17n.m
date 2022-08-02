% Script p4_7_17n.m; TDP for min time transfer to Jupiter orbit using
% FOPTN;		 		                           2/97, 3/28/02
%
clear; clear global; global rf; rf=5.2; c=pi/180;
be0=[-.099 -.036 .032  0.105 .185 .271 .362 .458 .555 .653 ...
   .750 .845 .937 1.023 1.104 1.179 1.247 1.309 1.365 1.415 ...
   1.458 1.495 1.522 2.417 4.758 4.772 4.790 4.808 4.825 4.841 ...
   4.856 4.871 4.886 4.900 4.914 4.928 4.942 4.957 4.972 4.987 4.994];
tf=8.216; nu=[-0.8009 2.6234 -0.7819]; p0=[be0 nu tf];
optn=optimset('Display','Iter','MaxIter',150); name='mart'; 
s0=[1 0 1 0]';
p=fsolve('foptn',p0,optn,name,s0); [f,s,la0]=foptn(p,name,s0); 
be=p([1:41]); tf=p(45); xc=s(1,:).*cos(s(4,:)); yc=s(1,:).*sin(s(4,:));
th=s(4,:); xt=xc+.75*sin(be-th); yt=yc+.75*cos(be-th); th1=[0:6:360]*c;
xj=5.2*cos(th1); yj=5.2*sin(th1); xe=cos(th1); ye=sin(th1);
N1=length(th1); 
%
figure(1); clf; plot(xc,yc,xj,yj,'r--',0,0,'ro',xe,ye,'r--'); hold on;
for i=1:2:41, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.15,'r','-'); end;
grid; axis([-6 1 -.75*3 .75*4]); xlabel('x/ro'); ylabel('y/ro'); 
text(-2.5,-.8,'EARTH ORBIT'); text(-4.8,1.2,'JUPITER ORBIT');
text(-.5,.5,'SUN'); 
