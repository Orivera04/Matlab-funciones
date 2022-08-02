% Script e02_2_1.m; DVDP for max xf with gravity;   10/96, 6/18/02
%
N=20; ga=[1:-1/(N-1):0]; s0=[0 0]'; tf=1; k=-7; tol=5e-5; mxit=50;
[ga,s,la0]=dop0('dvdp0',ga,s0,tf,k,tol,mxit); gah=[ga ga(N)];
t=[0:1/N:1]; v=s(1,:); x=s(2,:);
%
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2\gamma/\pi'); subplot(212)
plot(t,v,t,x,'r--'); grid; xlabel('t/t_f') 
legend('v/gt_f','x/gt_f^2',2); 