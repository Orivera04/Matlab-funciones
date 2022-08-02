% Script p4_7_12n.m; VDP for min time to (xf,yf) with gravity, thrust,
% and drag; s=[V,x,y]';                                  1/94, 3/28/02
%
clear; clear global; global xf yf a; a=.05; yf=-.3; xf=1.98; 
name='vdpgtdt'; s0=[0 0 0]'; nu=[-.9904 -.3143]; tf=5;   
ga0=[-1.5604 -1.0436 -0.6469 -0.4252 -0.3066 -0.2429 -0.2076...
     -0.1877 -0.1763 -0.1701 -0.1663 -0.1641 -0.1628 -0.1621...
     -0.1616 -0.1613 -0.1610 -0.1605 -0.1598 -0.1588 -0.1568...
     -0.1538 -0.1483 -0.1383 -0.1214 -0.0912 -0.0378  0.0595...
      0.2373  0.5480  0.9985]; N=length(ga0)-1; p0=[ga0 nu tf];
optn=optimset('Display','Iter','MaxIter',10);
load p4_7_12n; p0=p;                             % Converged solution 
p=fsolve('foptn',p0,optn,name,s0); N1=N+1; c=180/pi;
[f,s,la0,nu]=foptn(p,name,s0); ga=c*p([1:N1]); tf=p(N1+3);
v=s(1,:); x=s(2,:); y=s(3,:); t=tf*[0:1/N:1]; ke=v.^2/2;
%
figure(1); clf; subplot(211), plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; xlabel('x/l'); ylabel('y/l'); axis([ 0 2 -.4 0])  
subplot(212); plot(ke,y,ke(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('V^2/2gl'); ylabel('y/l'); axis([ 0 .11 -.4 0])
%
figure(2); clf; plot(t,ga); grid; xlabel('t*sqrt(l/g)')
ylabel('\gamma (deg)'); axis([0 5 -90 70])

	
	