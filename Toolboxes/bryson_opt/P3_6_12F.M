% Script p3_6_12f.m; VDP for max range with gravity, thrust, drag, and
% specified yf with FOPCF; s=[V y x]';                   8/97, 5/28/02   
% 
la0=[.3205 1 1.5829]; nu=1.582; s0=[0 0 0]'; p0=[la0 nu]; tf=5; 
name='vdpctd'; optn=optimset('Display','Iter','MaxIter',500); 
global a yf; a=.05; yf=-.3;
p=fsolve('fopcf',p0,optn,name,s0,tf); c=180/pi;
[f,t,y]=fopcf(p,name,s0,tf); N=length(t); v=y(:,1); x=y(:,2);
y1=y(:,3); lv=y(:,4); lx=y(N,5); ly=y(N,6); ga=atan2(v*ly-lv,v*lx);
% 
figure(1); clf; subplot(211), plot(x,y1,x,y1,'.',x(N),y1(N),'ro',...
   0,0,'ro'); grid; xlabel('x/l'); ylabel('y/l'); axis([0 2 -.5 0]);
subplot(212); plot(v,y1,v(N),y1(N),'ro',0,0,'ro'); grid;
xlabel('V/sqrt(gl)'); ylabel('y/l');
%
figure(2); clf; plot(t,c*ga,t,c*ga,'.'); grid
xlabel('t*sqrt(l/g)'); ylabel('Gamma (deg)');

% NOTE this is a problem with dissipation (drag) and single shooting
% does NOT WORK here for tf > about 3! See p3_6_12n.
