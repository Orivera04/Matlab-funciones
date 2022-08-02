% Script p2_5_6f.m; DVDP for max xf with gravity, thrust, drag using 
% DOP0F; (x,y) in l, V in sqrt(gl), t in sqrt (l/g);   5/97, 3/28/02
%
clear global; global a; a=2; N=20; name='dvdp0td'; s0=[0 0 0]';
tf=3; la0=[.4908 1 0]'; u0=-1.1401; 
optn=optimset('Display','Iter','MaxIter',50);
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N); N1=N+1; 
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N); s=real(s); t=tf*[0:1/N:1];
v=s(1,:); x=s(2,:); y=s(3,:); c=180/pi; uh=real(c*[u u(N)]);
%
figure(1); clf; subplot(211),plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; axis([0 4 -1 0]); ylabel('y/g*tf^2'); xlabel('x/g*tf^2');
subplot(212), zohplot(t,uh); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)');

% NOTE this is a short problem (tf=3) with dissipation (drag), & 
% single-shooting works. However, it does NOT work for tf> about 4.