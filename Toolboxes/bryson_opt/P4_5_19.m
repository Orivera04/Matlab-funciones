% Script p4_5_19.m; TDP for min time orbit injection from the 
% surface of the moon;                             11/96, 9/5/02
%
clear; name='lunt'; be0=[1:-.1:-1]'; N=length(be0)-1; tf=.5;
mxit=12; tu=tf*[0:1/N:1]'; s0=[1 0 0]'; k=1; told=1e-4; 
tols=3e-4;   
[t,be,s,tf,nu,la0]=fopt(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(r);
x=r.*sin(th); y=r.*cos(th); xm=sin(th); ym=cos(th); 
t1(N1)=tf*(1-1e-8); xo=1.1129*sin(th); yo=1.1129*cos(th);
xt=x+.03*cos(be-th); yt=y+.03*sin(be-th); t=t/tf;
%
figure(1); clf; plot(x,y,xm,ym,'r--',xo,yo,'r--',x(N1),...
    y(N1),'ro',0,1,'ro'); grid; hold on
for i=1:2:N1, 
  pltarrow([x(i) xt(i)],[y(i) yt(i)],.005,'r','-'); end
axis([-.02 .23 .98 1.12]); hold off; xlabel('x/r_{moon}')
ylabel('y/r_{moon}');
%
figure(2); clf; plot(t,u,t,v,t,r); grid; xlabel('Time')
axis([0 1 0 1.2]); legend('u','v','r',2);