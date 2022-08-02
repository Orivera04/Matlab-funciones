% Script p8_5_8.m; TDP for max uf w. spec. (vf,yf) using FOP0N2;
% s=[u v y x]'; (cf. p3_4_06.m); plus a nbr. opt. path;    7/12/02
%
global K; load p2_7_8; name='tdp0'; s0=zeros(4,1); tf=1; tol=1e-5;
mxit=5; [t,th,s,K,Hu,Huu]=fop0n2(name,tu,th0,s0,tf,tol,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); N=length(t);
%
figure(1); clf; subplot(211), plot(x,y,x(N),y(N),...
    'bo',0,0,'bo'); grid; axis([0 .45 0 .2])
xlabel('x/at_f^2'); ylabel('y/at_f^2'); hold on
subplot(212), plot(t,K(:,[2 3])); grid; xlabel('t/t_f')
legend('K_v','K_y',2)
%
figure(2); clf; subplot(211), plot(t,180*th/pi); grid
ylabel('\theta (deg)'); axis([0 1 -70 70]) 
subplot(212), plot(t,[u v]); grid; xlabel('t/t_f')
axis([0 1 0 .8]); legend('u/at_f','v/at_f',2)
%
% A nbr. opt. path:
global tn thn sn; tn=t; thn=th; sn=s; 
optn=odeset('RelTol',1e-4); s0=[0 0 .04 0]'; 
[t1,s1]=ode23('tdp0s',[0 tf],s0,optn);
y1=s1(:,3); x1=s1(:,4); N1=length(x1);
figure(1); subplot(211), plot(x1,y1,'r--',x1(N1),...
    y1(N1),'ro',0,.05,'ro'); hold off