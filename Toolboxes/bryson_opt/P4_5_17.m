% Script p4_5_17.m; TDP for min time transfer to Jupiter orbit;
%                                                         2/94, 9/5/02
%
clear; clear global; global rf; rf=5.2; name='mart'; k=2; told=1e-5; 
be0=[-0.099 -.036  0.032  0.105 0.185 0.271 0.362 0.458 0.555 0.653 ...
   0.750  .845 .937 1.023 1.104 1.179 1.247 1.309 1.365 1.415 ...
   1.458 1.495 1.522 2.417 4.758 4.772 4.790 4.808 4.825 4.841 ...
   4.856 4.871 4.886 4.900 4.914 4.928 4.942 4.957 4.972 4.987 4.994]';
tf=8.216; N=length(be0)-1; tu=tf*[0:1/N:1]'; 
s0=[1 0 1]'; tols=3e-3; mxit=50;
load p4_5_17; [N1,dum]=size(tu); N=N1-1; tf=tu(N1); % Converged solution
[t,be,s,tf,nu,la0]=fopt(name,tu,be0,tf,s0,k,told,tols,mxit);
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); xc=r.*cos(th);
yc=r.*sin(th); N1=length(u); t1(N1)=tf*(1-1e-8);
xt=xc+.75*sin(be-th); yt=yc+.75*cos(be-th); th1=[0:6:360]*pi/180;
xj=5.2*cos(th1); yj=5.2*sin(th1); xe=cos(th1); ye=sin(th1); 
%
figure(1); clf; plot(xc,yc,xj,yj,'r--',0,0,'ro',xe,ye,'r--'); hold on
for i=1:2:N1, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.15,'r','-'); end
grid; axis([-6 1 -.75*3 .75*4]); xlabel('x/ro'); ylabel('y/ro') 
text(-2.5,-.8,'EARTH ORBIT'); text(-4.8,1.2,'JUPITER ORBIT')
text(-.5,.5,'SUN') 
