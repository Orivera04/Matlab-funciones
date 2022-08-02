% Script p4_7_12b.m; VDP for min time to (xf,yf) with gravity,
% thrust, & drag using FOPTB; s=[V,x,y]';       6/97, 3/28/02
%
sf=[.1812 1.9798 -.3012]; nu=[-2.9611 -4.6536]; tf=4.9753;
p0=[sf nu tf]; s0=[0 0 0]'; c=180/pi; 
optn=optimset('Display','Iter','MaxIter',100);
name='vdpgtdt'; p=fsolve('foptb',p0,optn,name,s0);
[f,t,y]=foptb(p,name,s0); N=length(t);
tf=p(6); v=y(:,1); x=y(:,2); y1=y(:,3); 
lv=y(:,4); lx=y(N,5); ly=y(N,6);           % lx,ly are const
ga=c*atan2(-v*ly+lv,-v*lx);      % -signs for right quadrant
% 
figure(1); clf; subplot(211),
plot(x,y1,x,y1,'.',x(N),y1(N),'o',0,0,'o'); grid
xlabel('x/l'); ylabel('y/l'); subplot(212);
plot(v,y1,v,y1,'.',v(N),y1(N),'o',0,0,'o'); grid
xlabel('V/sqrt(gl)'); ylabel('y/l')
%
figure(2); clf; plot(t,ga,t,ga,'.'); grid
xlabel('t*sqrt(l/g)'); ylabel('\gamma (deg)');
axis([0 3 -90 20]);
%
% NOTE this is a problem with dissipation (drag) and single shooting
% does NOT WORK here for tf > about 3!

	-0.9528   -2.9611   -4.6536   -2.9611   -4.6536
	