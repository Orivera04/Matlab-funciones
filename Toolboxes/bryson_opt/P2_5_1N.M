% Script p2_5_1n.m; DVDP for max range with gravity using DOPON;
%                                                  4/97, 3/28/02
%
N=10; u=(pi/2)*[1:-1/N:1/N]; name='dvdp0'; s0=[0 0]'; tf=1;
optn=optimset('Display','Iter','MaxIter',100); 
u=fsolve('dop0n',u,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); v=s(1,:); x=s(2,:); t=[0:1/N:1];
uh=[u u(N)];
%
figure(1); clf; subplot(211), plot(t,s,t,s,'.'); grid;
legend('v/gt_f','x/gt_f^2',2); subplot(212), zohplot(t,2*uh/pi);  
grid; axis([0 1 0 1]); xlabel('t/t_f'); ylabel('2\gamma/pi');
	
	