% Script p2_5_5b.m; DVDP for max xf w. gravity & thrust using DOP0B;
%                                                      4/97, 3/28/02
%
clear; clear global; global a; a=2; N=10; uf=.03; ga=[1:-1/(N-1):0];
sf=[2.4332 1.2083 .3469]'; s0=[0 0 0]'; tf=1; N1=N+1; 
optn=optimset('Display','Iter','MaxIter',10); name='dvdpt0'; 
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u]=dop0b(sf,name,uf,s0,tf,N); x=s(2,:); y=s(3,:);
gah=[ga ga(N)]; t=[0:1/N:1];
%
figure(1); clf; plot(x,-y,x,-y,'.',x(N1),-y(N1),'ro',0,0,'ro');
grid; xlabel('x/gt_f^2'); ylabel('-y/gt_f^2')
%
figure(2); subplot(211), zohplot(t,2*gah/pi); grid; axis([0 1 0 1])
ylabel('2\gamma/pi'); subplot(212), plot(t,s); grid; xlabel('t/t_f') 
legend('v/gt_f','x/gt_f^2','y/gt_f^2')
	
	
