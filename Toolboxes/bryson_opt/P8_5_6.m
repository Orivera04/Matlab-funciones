% Script p8_5_6.m; VDP with gravity, thrust, drag & spec. yf; 
% s=[V x y]'; t in sqrt(l/g), V in sqrt(gl), (x,y) in l, a in g; 
% using FOP0N2; plus a nbr. opt. path;                   7/12/02
%
global a yf sy K; a=.05; yf=2; sy=2e2; name='vdptd0y';  
load p2_7_6; uf=u0; s0=[0 0 0]'; tf=5; tol=1e-5; mxit=5;
[t,uf,s,K,Hu,Huu]=fop0n2(name,tu,uf,s0,tf,tol,mxit);
V=s(:,1); x=s(:,2); y=s(:,3); N=length(V); c=180/pi; 
%
figure(1); clf; subplot(211), plot(x,-y,'b',0,0,'bo',...
   x(N),-y(N),'bo'); grid; xlabel('x'); ylabel('-y'); hold on
axis([0 3 -2.1 .1]); subplot(212), plot(V.^2/2,-y,'b',...
    V(N)^2/2,-y(N),'bo',0,0,'bo'); grid; xlabel('V^2/2')
ylabel('-y'); axis([0 .33 -2.1 .1]); hold on
%
figure(2); clf; subplot(311), plot(t,c*uf,'b'); grid
ylabel('\gamma (deg)'); axis([0 tf 0 90]) 
subplot(312), semilogy(t,K(:,[1 3])); ylabel('Fdbk Gains')
grid; legend('K_v','K_y',2); subplot(313)
plot(t,Huu); grid; ylabel('H_{uu}'); xlabel('Time')
%
% A nbr. opt. path:
global tn ufn sn; tn=t; ufn=uf; sn=s; 
optn=odeset('RelTol',1e-4); s0=[0 0 .35]'; 
[t1,s1]=ode23('vdptd0ys',[0 tf],s0,optn);
V1=s1(:,1); x1=s1(:,2); y1=s1(:,3); N1=length(x1);
figure(1); subplot(211), plot(x1,-y1,'r--',x1(N1),...
    -y1(N1),'ro',0,-.35,'ro'); hold off
subplot(212), plot(V1.^2/2,-y1,'r--',V1(N1)^2/2,-y1(N1),...
    'ro',0,-y1(1),'ro'); hold off