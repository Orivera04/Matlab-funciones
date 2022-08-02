% Script p4_3_12.m; DVDP for min tf with gravity, thrust, drag,
% to spec. (xf,yf); s=[v x y]'; (x,y) in l, V in sqrt(gl), t in 
% sqrt (l/g);                                         5/97, 3/31/02
%
clear; clear global; global a xf yf; a=.05; xf=1.9777; yf=-.3;  
N=15; u0=-.16*ones(1,N); s0=[0 0 0]'; tf=5; k=1.2; tol=1e-4;
mxit=50; c=180/pi; [u,s,nu,la0]=dopt('dvdpttd',u0,s0,tf,k,tol,mxit);
s=real(s); v=s(1,:); x=s(2,:); y=s(3,:); uh=c*real([u u(N)]);
N1=N+1; t=tf*[0:1/N:1]; ke=v.^2/2;
%
figure(1); clf; subplot(211), plot(x,y,x,y,'b.',x(N1),y(N1),...
    'ro',0,0,'ro'); grid; axis([0 2 -.4 0]); ylabel('y/gt_f^2'); 
xlabel('x/gt_f^2');
subplot(212); plot(ke,y,ke,y,'.',ke(N1),y(N1),'o',0,0,'o');
grid; xlabel('V/sqrt(gl)'); ylabel('y/l'); axis([0 .12 -.4 0]);
%
figure(2); clf; zohplot(t,uh); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)');

 
	
