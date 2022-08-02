% Script e02_5_1.m; DVDP for max range with gravity using DOPON;
%                                                            3/97, 6/18/02
%
N=10; u=(pi/2)*[1:-1/N:1/N]; name='dvdp0'; s0=[0 0]'; tf=1; 
optn=optimset('Display','Iter','MaxIter',100);
u=fsolve('dop0n',u,optn,name,s0,tf); [f,s,la0]=dop0n(u,name,s0,tf); 
v=s(1,:); x=s(2,:); t=[0:1/N:1]; gah=[u u(N)];
%
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2\gamma/\pi'); subplot(212), plot(t,v,t,x,'r--');
grid; xlabel('t/t_f'); legend('v/gt_f','x/gt_f^2',2) 
	