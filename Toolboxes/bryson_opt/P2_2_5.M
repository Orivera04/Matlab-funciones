% Script p2_2_5.m; DVDP for max xf using gravity and thrust; (x,y) in
% units of gtf^2, v in gt_f, a in g;              4/97, 1/98, 3/23/02
%
global a; a=1.5; N=10; ga=[1:-1/(N-1):0]; s0=[0 0 0]'; tf=1; k=-7;
tol=5e-5; N1=N+1; [ga,s,la0]=dop0('dvdpt0',ga,s0,tf,k,tol);
t=[0:1/N:1]; V=s(1,:); x=s(2,:); y=s(3,:); gah=[ga ga(N)];
%
figure(1); clf; plot(x,-y,'b',x,-y,'b.',x(N1),-y(N1),'ro',0,0,'ro');
grid; axis('square'); xlabel('x/gt_f^2'); ylabel('-y/gt_f^2')
%
figure(2); clf; subplot(211), zohplot(t,2*gah/pi); grid
ylabel('2\gamma/\pi'); subplot(212), plot(t,V); grid 
xlabel('t/t_f'); ylabel('v/gt_f')
	
	
