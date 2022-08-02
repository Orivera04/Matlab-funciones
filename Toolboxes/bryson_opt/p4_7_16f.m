% Script p4_7_16f.m; max time constant-altitude glide to xf=yf=0,
% vf=.3575 using FOPTF (Ping Lu); s=[x y v ps]';      9/97, 3/28/02
%
la0=[-.066 .070 8.989 .140]; nu=[-.066 .070 17.20]; tf=9.56;
p0=[la0 nu tf]; s0=[-2 0 1 0]'; name='calgldt'; 
optn=optimset('Display','Iter','MaxIter',10);
p=fsolve('foptf',p0,optn,name,s0); [f,t,y]=foptf(p,name,s0); tf=p(8);
c=pi/180; x=y(:,1); y1=y(:,2); v=y(:,3); ps=y(:,4)/c; lv=y(:,7);
lp=y(:,8); E=20; om=.23; u=atan2(E*v.*lp,om*lv)/c; N=length(t);
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',x(N),y1(N),'ro'); grid
axis([-2.5 1.5 0 4]); axis('square'); xlabel('x'); ylabel('y') 
%
figure(2); clf; subplot(311); plot(t,u); grid; ylabel('\sigma (deg)')
subplot(312), plot(t,v); grid; ylabel('v')
subplot(313), plot(t,ps); grid; ylabel('\psi (deg)')
xlabel('Normalized time');
