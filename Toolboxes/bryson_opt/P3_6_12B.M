% Script p3_6_12b.m; VDP for max range with gravity, thrust, drag and 
% specified yf with FOPCB; s=[V y x]';                  8/97, 5/28/02   
% 
sf=[.1797 1.987 -.3]; nu=1.582; p0=[sf nu]; s0=[0 0 0]';
tf=5; name='vdpctd'; optn=optimset('Display','Iter','MaxIter',500); 
global a yf; a=.05; yf=-.3; p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); N=length(t); 	
v=y(:,1); x=y(:,2); y1=y(:,3); lv=y(:,4); lx=y(:,5);
ly=y(:,6); ga=atan2(ly-lv./v,v.*lx); c=180/pi;
% 
figure(1); clf; subplot(211), plot(x,y1,x,y1,'.',x(N),y(N),'o');
grid; hold on; plot(0,0,'o'); hold off; xlabel('x/l')
ylabel('y/l'); axis([0 2 -.5 0]) 
title('VDP for Max xf with Thrust, Gravity, Drag & yf=-.3')
subplot(212); plot(v,y1,v,y1,'.',v(N),y1(N),'o',0,0,'o');
grid; xlabel('V/sqrt(gl)'); ylabel('y/l')
%
figure(2); clf; plot(t,c*ga,t,c*ga,'.'); grid
xlabel('t*sqrt(l/g)'); ylabel('Gamma (deg)')

% NOTE this is a problem with dissipation (drag) and single shooting
% does NOT WORK here for tf > about 3! See p3_5_12n.

