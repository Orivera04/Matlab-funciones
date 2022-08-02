% Script p3_5_11n.m; DVDP for max range with gravity, thrust, and spec.
% yf using DOPCN; t in tf, a in g, v in g*tf, (x,y) in g*tf^2;
%                                                          2/94, 5/27/02
%
clear; clear global; global a yf; a=.5; yf=.1; N=20; ga0=[-1:2/N:1-2/N];
s0=[0 0 0]'; tf=1; name='dvdpct'; nu=1.582; p0=[ga0 nu];
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dopcn',p0,optn,name,s0,tf); c=180/pi;  
[f,s,la0]=dopcn(p,name,s0,tf); ga=p([1:N]); N1=N+1; x=s(2,:); y=s(3,:);
t=tf*[0:1/N:1]; gah=c*[ga ga(N)];
%
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')
%
figure(2); clf; zohplot(t,gah); grid; xlabel('t/t_f')
ylabel('\gamma (deg)'); axis([0 1 -90 90])

