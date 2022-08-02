% Script p3_5_12n.m; DVDP for max xf with gravity, thrust, drag, and
% spec. yf using DOPCN; (x,y) in l, V in sqrt(gl), t in sqrt (l/g);
%                                                      5/97, 5/27/02
%
clear; clear global; global a yf; a=.05; yf=-.3;
u0=[-1.166  -.580 -.327 -.229 -.190 -.173 -.166 -.163 -.161 -.161 ...
   -.160 -.160 -.159 -.156 -.150 -.136 -.102 -.020 .185 .660];
N=length(u0); s0=[0 0 0]'; tf=5; nu=1.59; p0=[u0 nu];
name='dvdpctd'; optn=optimset('Display','Iter','MaxIter',20); 
t=tf*[0:1/N:1]; c=180/pi;
p=fsolve('dopcn',p0,optn,name,s0,tf); t=[0:N]/N; 
[f,s,la0]=dopcn(p,name,s0,tf); s=real(s); ga=real(p([1:N])); N1=N+1;  
x=s(2,:); y=s(3,:); v=s(1,:); ke=v.^2/2; nu=p(N1); 
gah=c*[ga ga(N)]; N1=N+1; t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211); plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; axis([0 2 -.4 0]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
subplot(212); plot(ke,y,ke,y,'b.',ke(N1),y(N1),'ro',0,0,'ro');
grid; xlabel('V^2/g*l'); ylabel('y/l'); axis([0 .12 -.4 0])
%
figure(2); clf; subplot(211), plot(t,v); grid; ylabel('V')
subplot(212), zohplot(t,gah); grid; xlabel('t*sqrt(l/g)')
ylabel('\gamma (deg)')






