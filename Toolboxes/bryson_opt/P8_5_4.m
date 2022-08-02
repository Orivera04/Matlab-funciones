% Script p8_5_4.m; max range, given tf, with V=1+y and spec. yf 
% (Fermat Pb.) using FOP0N2; plus a nbr. opt. path;     8/10/02
%
global yf sy K; yf=0; sy=2e2; name='frm0y'; 
load p2_7_4; u0=u0'; tu=tu'; tf=2; tol=1e-4; mxit=3;
s0=[0 0]'; [t,uf,s,K,Hu,Huu]=fop0n2(name,tu,u0,s0,tf,tol,mxit);
x=s(:,1); y=s(:,2); N1=length(x);
%
figure(1); clf; subplot(311), plot(x,y,x(N1),y(N1),'ro',...
  0,0,'ro'); hold on; subplot(312), semilogy(t,K(:,2)); grid
ylabel('K_y'); subplot(313), plot(t,Huu); grid
ylabel('H_{uu}'); axis([0 2 -1.6 0]); xlabel('Time')
%
% A Nbr. Opt. path:
global tn ufn sn; tn=t; ufn=uf; sn=s; 
optn=odeset('RelTol',1e-4); s0=[0 .1]'; 
[t1,s1]=ode23('frm0ys',[0 tf],s0,optn);
x1=s1(:,1); y1=s1(:,2); N2=length(x1);
figure(1); subplot(311), plot(x1,y1,'r--',x1(N2),y1(N2),...
  'ro',0,.1,'ro'); grid; axis([0 2.5 -.1 .8]); xlabel('x')
ylabel('y'); hold off	 
	   
	
	
