% Script p8_5_1.m; VDP for max range w. gravity & specified tf 
% and yf using a penalty function & FOP0N2; s=[V x y]'; plus
% a nbr. opt. path & corres. exact opt. path;          8/19/02
%
global yf sy K; yf=.3; sy=2e2; tf=1; load p2_7_1;
name='vdp0y'; y0=[-.03 0]; tol=1e-5; mxit=8; 
figure(1); clf; figure(2); clf;
for i=1:2, s0=[0 0 y0(i)]'; 
 [t,uf,s,K,Hu,Huu]=fop0n2(name,tu,u0,s0,tf,tol,mxit);
 x=s(:,2); y=s(:,3); N1=length(x);
 figure(1); plot(x,-y,x(N1),-y(N1),'ro',0,-y0(i),'ro'); 
 hold on
 figure(2); subplot(211), plot(t,uf*180/pi); hold on
end; figure(2), subplot(211), grid; axis([0 tf 0 90])
ylabel('\gamma (deg)'); hold off
figure(2); subplot(212), semilogy(t,K(:,[1 3])); grid
ylabel('Fdbk Gains'); legend('K_v','K_y',4); xlabel('Time')
%
% A nbr. opt. path:
global tn un sn; tn=t; un=uf; sn=s; 
optn=odeset('RelTol',1e-4); s0=[0 0 y0(1)]'; 
[t1,s1]=ode23('vdp0ys',[0 tf],s0,optn); 
x1=s1(:,2); y1=s1(:,3); 
figure(1); plot(x1,-y1,'r.'); grid; axis([0 .44 -.31 .03])
xlabel('x'); ylabel('y'); hold off
