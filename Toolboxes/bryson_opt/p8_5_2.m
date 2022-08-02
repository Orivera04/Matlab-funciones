% Script p8_5_2.m; VDP for max range w. V=Vo*y/h and soft TC on
% y-yf; path & gains from implicit analytical solution and numerical
% solution; nbr. opt. path from integation of perturb. eqns;  7/9/02
%
y0a=[.2 0]; yf=0; sf=2e2; tf=2; z0=atan(tf)*[1 -1];
optn=optimset('Display','Iter');
figure(1); clf; figure(2); clf;
for i=1:2, y0=y0a(i);
 z=fsolve('zrm0a',z0,optn,sf,yf,y0,tf); th0=z(1); thf=z(2);
 N=60; un=ones(1,N+1); th=th0+(thf-th0)*[0:1/N:1]; ta=tan(th);
 ta0=tan(th0); se=un./cos(th); se0=1/cos(th0); t=un*ta0-ta;
 x=t*(se0+y0)+(log((se0+ta0)*un./(se+ta))+ta.*se-un*ta0*se0)/2;
 y=un*(y0+se0)-se;   
 %
 figure(1); subplot(311), plot(x,y,x(N+1),y(N+1),'ro',0,y0,'ro'); 
 axis([0 2.5 0 .6]); xlabel('x/h'); ylabel('y/h'); hold on
 title('VDP for Max Range w. u_c=V_oy/h & yf=0')
 subplot(312),plot(t,180*th/pi); hold on;  axis([ 0 tf -50 50])
 ylabel('\theta (deg)')
end
%
% Analytical feedback gains K(t):
K=(cos(th)).^2./(un*(1/sf-sin(thf))+sin(th)); subplot(313)
semilogy(t,K); grid; ylabel('Fdbk Gain'); xlabel('V_ot/h')
axis([0 tf .1 100])
%
% A neighboring optimal path:
tn=t'; thn=th; sn=[x' y']; ds0=[0 .2]'; optn=odeset('reltol',1e-3);
[t1,ds]=ode23('zrm0_noc',[0 tf],ds0,optn,tn,thn,sn,K);
ds1=interp1(t1,ds,tn); dx=ds1(:,1); dy=ds1(:,2); dth=-K.*dy'; 
th1=thn+dth; s1=sn+ds1; x1=s1(:,1); y1=s1(:,2); 
%
figure(1); subplot(311),plot(x1,y1,'r.'); grid; hold off
subplot(312), plot(t,180*th1/pi,'r.'); grid; hold off
%
% Numerical calculation of path and K(t) using FOP0N2 
%
clear; load p8_5_2; name='zrm0n2'; s0=[0 0]'; tf=2; tol=1e-6;
mxit=5; [tu,uf,s,K,Hu,Huu]=fop0n2(name,tu,uf,s0,tf,tol,mxit);
x=s(:,1); y=s(:,2); N=length(tu);  
%
figure(2); subplot(311), plot(x,y,x(N),y(N),'ro',0,0,'ro'); 
axis([0 2.5 0 .6]); grid; xlabel('x/h'); ylabel('y/h'); 
title('VDP for Max Range w. u_c=V_oy/h & yf=0')
subplot(312), plot(tu,180*uf/pi); axis([ 0 tf -50 50])
grid; ylabel('\theta (deg)')
subplot(313), semilogy(tu,K); grid; ylabel('K_y'); xlabel('Vt/h')
axis([0 tf .1 100])

   