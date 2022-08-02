% Script p4_7_16n.m; max time constant-altitude glide to xf=yf=0,
% vf=.3575 using FOPTN (Ping Lu); s=[x y v ps]';      9/97, 3/28/02
%
u0=[.935 .826 .695 .550 .399 .253 .120 .002 -.100 -.186 -.260 ...
   -.322 -.373 -.415 -.479 -.472 -.488 -.496 -.450 -.489 -.475...
   -.456 -.423 -.405 -.375 -.344 -.312 -.280 -.250 -.220 -.192 ...
   -.166 -.142 -.119 -.098 -.079 -.061 -.044 -.029 -.014  0];
nu0=[-.066 .070 17.20]; tf0=9.56; p0=[u0 nu0 tf0]; s0=[-2 0 1 0]';
N=40; name='calgldt'; 
optn=optimset('Display','Iter','MaxIter',10);
p=fsolve('foptn',p0,optn,name,s0); [f,s,la0]=foptn(p,name,s0);
tf=p(8); u=p([1:N+1]); nu=p([N+2:N+4]); tf=p(N+5); x=s(1,:); y=s(2,:);
v=s(3,:); c=pi/180; ps=s(4,:)/c; t=tf*[0:1/40:1];
%
figure(1); clf; plot(x,y,x(1),y(1),'ro',x(N),y(N),'ro'); grid
axis([-2.5 1.5 0 4]); axis('square'); xlabel('x'); ylabel('y') 
%
figure(2); clf; subplot(311); plot(t,u); grid; ylabel('\sigma (deg)')
subplot(312), plot(t,v); grid; ylabel('v')
subplot(313), plot(t,ps); grid; ylabel('\psi (deg)')
xlabel('Normalized time');
