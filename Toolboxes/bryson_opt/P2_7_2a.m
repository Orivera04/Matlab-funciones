% Script p2_7_2a.m; VDP for max range with V=Vo*y/h and soft TC 
% on y-yf; path from implicit analytical solution & FSOLVE;
%                                                        7/3/02
%
y0a=[.2 0]; yf=0; sf=2e2; tf=2; p0=atan(tf)*[1 -1];
optn=optimset('Display','Iter'); figure(1); clf; 
for i=1:2, y0=y0a(i);
 p=fsolve('zrm0a',p0,optn,sf,yf,y0,tf); th0=p(1); thf=p(2);
 N=60; un=ones(1,N+1); th=th0+(thf-th0)*[0:1/N:1]; ta=tan(th);
 ta0=tan(th0); se=un./cos(th); se0=1/cos(th0); t=un*ta0-ta;
 x=t*(se0+y0)+(log((se0+ta0)*un./(se+ta))+ta.*se-un*ta0*se0)/2;
 y=un*(y0+se0)-se;   
 %
 figure(1); subplot(211), plot(x,y,x(N+1),y(N+1),'ro',0,y0,'ro'); 
 axis([0 2.5 0 .6]); xlabel('x/h'); ylabel('y/h'); hold on
 title('VDP for Max Range with V=V_oy/h & yf=0')
 subplot(212),plot(t,180*th/pi); hold on;  axis([ 0 tf -50 50])
 ylabel('\theta (deg)')
end; subplot(211); grid; hold off; subplot(212); grid; hold off
