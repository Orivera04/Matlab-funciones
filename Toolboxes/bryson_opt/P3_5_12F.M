% Script p3_5_12f.m; DVDP for max range with gravity, thrust, drag 
% and specified yf with DOPCF; s=[V y x]';           2/98, 5/27/02
%
N=20; la0=[0.3289 1 1.5859]; nu=1.5859; p0=[la0 nu]; ga0=-1.048;
s0=[0 0 0]'; tf=5; name='dvdpctd'; global a yf; a=.05; yf=-.3;
optn=optimset('Display','Iter','MaxIter',3); 
p=fsolve('dopcf',p0,optn,name,ga0,s0,tf,N);
[f,s,ga,la]=dopcf(p,name,ga0,s0,tf,N); s=real(s); ga=real(ga);
N1=N+1; x=s(2,:); y=s(3,:); v=s(1,:); ke=v.^2/2; nu=p(N1); 
gah=c*[ga ga(N)]; N1=N+1; t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211); plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; axis([0 2 -.4 0]); ylabel('y/g*tf^2'); xlabel('x/gt_f^2')
subplot(212); plot(ke,y,ke,y,'b.',ke(N1),y(N1),'ro',0,0,'ro');
grid; xlabel('V^2/g*l'); ylabel('y/l'); axis([0 .12 -.4 0])
%
figure(2); clf; subplot(211), plot(t,v); grid; ylabel('V')
subplot(212), zohplot(t,gah); grid; xlabel('t*sqrt(l/g)')
ylabel('\gamma (deg)')
%
% NOTE this is a problem with dissipation (drag) and single 
% shooting does NOT WORK here for tf > about 3.
