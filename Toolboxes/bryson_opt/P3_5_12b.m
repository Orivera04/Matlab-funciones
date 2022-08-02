% Script p3_5_12b.m; DVDP for max range with gravity, thrust, drag and
% specified yf with DOPCF; s=[V y x]';                   2/98, 5/27/02
%
N=20; sf=[.1836 1.9815 -.3000]; global a yf; a=.05; yf=-.3; nu=1.5859;
p0=[sf nu]; gaf=.6609; s0=[0 0 0]'; tf=5; name='dvdpctd'; 
optn=optimset('Display','Iter','MaxIter',2);
p=fsolve('dopcb',p0,optn,name,gaf,s0,tf,N);
[f,s,ga,la]=dopcb(p,name,gaf,s0,tf,N); N1=N+1; s=real(s); ga=real(ga);
y=s(2,:); x=s(3,:); t=tf*[0:1/N:1]; c=180/pi; gah=c*[ga ga(N)];
% 
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;
axis([0 2.8 -.4 0]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
%
figure(2); clf; zohplot(t,gah); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)');
%
% NOTE this is a problem with dissipation (drag) and single
% shooting does NOT WORK here for tf > about 3.
