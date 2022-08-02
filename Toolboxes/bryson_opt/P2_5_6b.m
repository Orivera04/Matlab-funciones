% Script p2_5_6b.m; DVDP for max xf with gravity, thrust, drag using
% DOP0B; (x,y) in l, V in sqrt(gl), t in sqrt (l/g);   5/97, 3/28/02
%
clear global; global a; a=2; N=20; name='dvdp0td'; s0=[.01 0 0]';
tf=3; t=tf*[0:1/N:1]; sf=[1.454 3.747 -.866]'; uf=-.0446;
optn=optimset('Display','Iter','MaxIter',50);
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u]=dop0b(sf,name,uf,s0,tf,N); s=real(s); N1=N+1;
v=s(1,:); x=s(2,:); y=s(3,:); c=180/pi; uh=c*real([u u(N)]); 
%
figure(1); clf; subplot(211), plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); 
grid; axis([0 4 -1 0]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
%
figure(2); clf; zohplot(t,uh); grid; xlabel('t*sqrt(l/g)')
ylabel('\gamma (deg)')

% NOTE this is a problem with dissipation (drag) & single-shooting 
% does NOT work. Forward shooting does work and p2_5_6n is a direct
% non-shooting solution.

      