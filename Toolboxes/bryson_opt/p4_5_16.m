% Script p4_5_16.m; max time constant-altitude glide to xf=yf=0,
% vf=.3575 (Ping Lu); s=[x y v ps]'; control=sg;   9/97, 7/16/02
%
tf=9.6; c=pi/180; sg=c*[20 14 6 -4 -13 -26 -26 -21 -16 -8 0]';
N=length(sg)-1; tu=tf*[0:1/N:1]'; name='calgldt';
s0=[-2 0 1 0]'; k=-1; told=1e-4; tols=1e-4; mxit=30;
[t,sg,s,tf,nu,la0]=fopt(name,tu,sg,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); v=s(:,3); ps=s(:,4)/c; sg=sg/c; vf=.3575;
%
figure(1); clf; plot(x,y,0,0,'ro',-2,0,'ro'); grid;
axis([-2 2 -1 2]); xlabel('x'); ylabel('y');
%
figure(2); clf; subplot(211); plot(t,sg); grid
ylabel('\sigma (deg)'); xlabel('Normalized Time')
%
figure(3); clf; subplot(211), plot(t,v,tf,vf,'ro',0,1,'ro');
grid; ylabel('v'); subplot(212), plot(t,ps); grid
ylabel('\psi (deg)'); xlabel('Normalized time')

