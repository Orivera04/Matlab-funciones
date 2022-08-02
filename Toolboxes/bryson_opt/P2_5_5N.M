% Script p2_5_5n.m; DVDP for max xf w. gravity & thrust using DOP0N;
%                                                      4/97, 3/28/02
%
global a; a=2; N=10; ga=[1:-1/(N-1):0]; s0=[0 0 0]'; tf=1; N1=N+1;
t=[0:1/N:1]; [f,s,la0]=dop0n(ga,'dvdpt0',s0,tf); x=s(2,:); y=s(3,:);
gah=[ga ga(N)];
%
figure(1); clf; plot(x,-y,x,-y,'.',x(N1),-y(N1),'o',0,0,'o'); grid;
xlabel('x/gt_f^2'); ylabel('-y/gt_f^2');
%
figure(2); subplot(211), zohplot(t,2*gah/pi); grid; axis([0 1 0 1])
ylabel('2\gamma/pi'); subplot(212), plot(t,s); grid; xlabel('t/t_f')
legend('v/gt_f','x/gt_f^2','y/gt_f^2',2);
	
	
