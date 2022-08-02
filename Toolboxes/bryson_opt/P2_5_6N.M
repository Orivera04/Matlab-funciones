% Script p2_5_6n.m; DVDP for max xf with gravity,  thrust, drag
% using DOP0N; (x,y) in l, V in sqrt(gl), t in sqrt (l/g);    
%                                                  5/97, 3/29/02
%
clear global; global a; a=2; N=20; name='dvdp0td'; s0=[0 0 0]';
tf=3; c=180/pi; k=-6; u0=-.15*ones(1,N); tol=1e-5; mxit=50; 
[u,s]=dop0(name,u0,s0,tf,k,tol,mxit); t=tf*[0:1/N:1];
optn=optimset('Display','Iter','MaxIter',100); 
u=fsolve('dop0n',u,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); s=real(s); v=s(1,:); x=s(2,:); 
y=s(3,:); N1=N+1; uh=c*real([u u(N)]); 
%
figure(1); clf; subplot(211), plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; axis([0 4 -1 0]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
subplot(212), zohplot(t,uh); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)');



