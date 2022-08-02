% Script p2_5_1b.m;  DVDP for max xf w. gravity using DOP0B; 
%                                                 3/97, 3/28/02
%
N=10; sf=[.6392 .3157]'; uf=0; s0=[0 0]'; tf=1;
name='dvdp0'; optn=optimset('Display','Iter','MaxIter',50);
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u]=dop0b(sf,name,uf,s0,tf,N); gah=[u u(N)]; t=[0:N]/N;
%
figure(1); clf; subplot(211), plot(t,s,t,s,'r'); grid 
legend('v/gt_f','x/gt_f^2',2); subplot(212), zohplot(t,2*gah/pi);
grid; axis([0 1 0 1]); xlabel('t/t_f'); ylabel('2\gamma/pi')