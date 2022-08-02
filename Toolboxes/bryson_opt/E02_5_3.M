% Script e02_5_3.m;  DVDP for max xf w. gravity using DOP0B;
%                                              3/97, 6/25/02
%
N=10; sf=[.6392 .3157]'; uf=0; s0=[0 0]'; tf=1; t=[0:1/N:1];
name='dvdp0'; optn=optimset('Display','Iter','MaxIter',50);
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u,la]=dop0b(sf,name,uf,s0,tf,N); v=s(1,:); x=s(2,:); 
gah=2*[u u(N)]/pi;
% 
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2\gamma/\pi'); subplot(212), 
plot(t,v,t,x,'r--'); grid; legend('v/gt_f','x/gt_f^2',2) 
xlabel('t/t_f') 