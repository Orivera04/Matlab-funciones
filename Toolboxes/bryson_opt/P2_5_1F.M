% Script p2_5_1f.m;  DVDP for max xf w. gravity using DOP0F; 
%                                                 3/97, 3/28/02
%
N=10; la0=[.6373 1]'; u0=1.5; s0=[0 0]'; tf=1; name='dvdp0';
optn=optimset('Display','Iter','MaxIter',50); 
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u]=dop0f(la0,name,u0,s0,tf,N); gah=[u u(N)]; t=[0:N]/N;
%
figure(1); clf; subplot(211), plot(t,s,t,s,'.'); grid
legend('v/gt_f','x/gt_f^2',2); subplot(212), zohplot(t,2*gah/pi);
grid; axis([0 1 0 1]); xlabel('t/t_f'); ylabel('2\gamma/pi');
   
   