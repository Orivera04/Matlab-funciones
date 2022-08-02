% Script p8_4_01.m; DVDP for max range with gravity using DOP0N2 
% w. quad. penalty on y(N)-yf; also a nbr. opt. path; s=[V x y]'; 
%                                                   4/97, 8/10/02
%
clear; clear global; global yf sy; yf=.1; sy=1e3; N=50;  
u0=(pi/2)*[1:-1/N:1/N]; s0=[0 0 0]'; tf=1; k=-15; tol=1e-4;
mxit=10; t=tf*[0:N]/N; u=dopc('dvdpc',u0,s0,tf,k,tol,mxit); 
tol=1e-7; [u,s,K,Hu,Zuu]=dop0n2('dvdp0n',u,s0,tf,tol);
uh=[u u(N)]; Kh=[K; K(N,:)]'; x=s(2,:); y=s(3,:); N1=N+1;
Zuuh=[Zuu Zuu(N)];
%
figure(1); clf; subplot(211), plot(x,-y,x(N1),-y(N1),'bo',...
  0,0,'bo'); grid; axis([0 .3 -.14 0]); hold on
ylabel('y/gt_f^2'); xlabel('x/gt_f^2'); subplot(212)
zohplot(t,2*uh/pi); grid; ylabel('2u/\pi'); xlabel('t/t_f')
hold on
%
figure(2); clf; subplot(211), zohplot(t,Kh([1 3],:)); grid
ylabel('Fdbk Gains'); legend('K_v','K_y',2); axis([0 1 0 110])
subplot(212), zohplot(t,Zuuh); grid; ylabel('Z_{uu}')
xlabel('t/t_f')
%
% A neighboring optimal path:
dt=tf/N; un=u; sn=s; s(:,1)=[0 0 .02]'; 
for i=1:N
    u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i)); co=cos(u(i)); 
    si=sin(u(i)); dl=dt*(s(1,i)+.5*si*dt);
    s(:,i+1)=[s(1,i)+si*dt; s(2,i)+co*dl; s(3,i)+si*dl];  
 end; uh=[u u(N)]; x=s(2,:); y=s(3,:); 
%
figure(1); subplot(211), plot(x,-y,'r--',x(1),-y(1),'ro',x(N1),...
   -y(N1),'ro'); subplot(212), zohplot(t,2*uh/pi,'r--'); 
%
% Exact neighboring optimum path for comparison:
s0=[0 0 .02]'; [ue,s]=dop0n2('dvdp0n',u,s0,tf,tol);
xe=s(2,:); ye=s(3,:); uhe=[ue ue(N)];   
%
figure(1); subplot(211), plot(xe,-ye,'r.'); hold off
subplot(212), zohplot(t,2*uhe/pi,'r.'); hold off

  
	