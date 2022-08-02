% Script p8_5_5.m; VDP for max range with gravity, thrust, & 
% spec. yf, using FOP0N2; a=g; plus a nbr. opt. path; 7/10/02
%
global a yf sy K; a=1; yf=.3; sy=2e2; name='vdpt0y'; 
load p2_7_5; s0=[0 0 0]';  tf=1; tol=1e-4; mxit=3;
[t,uf,s,K,Hu,Huu]=fop0n2(name,tu,u0,s0,tf,tol,mxit);
x=s(:,2); y=s(:,3); N=length(x);
%
figure(1); clf; subplot(311), plot(x,-y,x(N),-y(N),...
  'bo',0,0,'bo'); grid; axis([0 .8 -.4 0]); xlabel('x')
ylabel('y'); hold on; subplot(312), semilogy(t,K(:,[1 3])); 
grid; legend('K_v','K_y',2); subplot(313)
plot(t,Huu); grid; ylabel('H_{uu}'); xlabel('Time')
%
% A nbr. opt. path:
global tn ufn sn; tn=t; ufn=uf; sn=s; 
optn=odeset('RelTol',1e-4); s0=[0 0 .1]'; 
[t1,s1]=ode23('vdpt0ys',[0 tf],s0,optn);
x1=s1(:,2); y1=s1(:,3); N1=length(x1);
figure(1); subplot(311), plot(x1,-y1,'r--',x1(N1),...
    -y1(N1),'ro',0,-.1,'ro'); hold off