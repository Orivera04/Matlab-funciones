% Script e02_5_2.m;; DVDP for max range with gravity 
% using DOP0F;                                 3/97, 6/25/02             
%
N=5; s0=[0 0]'; tf=1;  N1=N+1; la0=[.6392 1]'; u0=1.4137;
name='dvdp0'; optn=optimset('Display','Iter','MaxIter',100);
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N);
v=s(1,:); x=s(2,:); t=tf*[0:1/N:1]; gah=[u u(N)];
% 
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2\gamma/\pi'); subplot(212),
plot(t,v,t,x,'r--'); grid; legend('v/gt_f','x/gt_f^2',2) 
xlabel('t/t_f') 
	
