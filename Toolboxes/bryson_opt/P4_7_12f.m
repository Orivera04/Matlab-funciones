% Script p4_7_12f.m; VDP for min time to (xf,yf) with gravity, thrust,
% & drag using FOPTF; s=[V,x,y]';                        1/94, 3/28/02
%
clear; clear global; global xf yf a; a=.05; yf=-.3; xf=1.98; 
la0=[-.9463 -2.9614 -4.6720]; nu=[-2.9614 -4.6720]; tf=4.9816;
s0=[0 0 0]'; p0=[la0 nu tf]; c=180/pi; 
optn=optimset('Display','Iter','MaxIter',5);
name='vdpgtdt'; p=fsolve('foptf',p0,optn,name,s0);
[f,t,y]=foptf(p,name,s0); N=length(t); tf=p(6); v=y(:,1);
x=y(:,2); y1=y(:,3); lv=y(:,4); lx=y(N,5); ly=y(N,6);  
ga=c*atan2(-v*ly+lv,-v*lx); ke=v.^2/2;
%
figure(1); clf; subplot(211), plot(x,y,x(N),y(N),'ro',0,0,'ro');
grid; xlabel('x/l'); ylabel('y/l'); axis([ 0 2 -.4 0]);  
subplot(212); plot(ke,y,ke(N),y(N),'ro',0,0,'ro'); grid;
xlabel('V^2/2gl'); ylabel('y/l'); axis([ 0 .12 -.4 0]);
%
figure(2); clf; plot(t,ga); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)'); axis([0 5 -90 70]);
%
% NOTE this is a problem with dissipation (drag) and single
% shooting does NOT WORK here for tf > about 3!




		