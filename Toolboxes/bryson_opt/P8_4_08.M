% Script p8_4_08.m; DTDP for max xf with gravity, and spec. yf, u0,
% v0 using DOP0N2; (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf, g in a;
% also a nbr. opt. path & corres. exact path;           4/97, 8/10/02
%
global g yf sf; g=1/3; yf=0; sf=2e4; N=20; u0=.5/sqrt(2); v0=u0;
z=pi/180; tf=1; th=z*21.95*ones(1,N); s0=[u0 v0 0 0]'; k=-12;
tol=1e-4; mxit=20; N1=N+1; th=dopc('dtdpgic',th,s0,tf,k,tol,mxit);
tol=1e-7; [th,s,K,Hu,Zuu]=dop0n2('dtdpgicn',th,s0,tf,tol); u=s(1,:);
v=s(2,:); x=s(3,:); y=s(4,:); Kh=[K; K(N,:)]; t=[0:N]/N; 
thh=[th th(N)]; Huh=[Hu Hu(N)]; Zuuh=[Zuu Zuu(N)];
%
figure(1); clf; subplot(311), plot(x,y,x(N1),y(N1),'bo',0,0,'bo');
grid; axis([0 .9 0 .1]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
hold on; subplot(312), plot(t,u,t,v,'b--'); grid; xlabel('t/t_f')
hold on; legend('u/at_f','v/at_f',2); subplot(313), zohplot(t,z*thh);
grid; axis([0 1 -25 0]); ylabel('\theta (deg)'); hold on 
%
figure(2); clf; subplot(311), zohplot(t',Kh); grid
ylabel('Fdbk Gains'); legend('K_u','K_v','K_x','K_y',2)
axis tight;  subplot(312), zohplot(t,Huh)
grid; ylabel('H_u'); subplot(313), zohplot(t,Zuuh); grid
ylabel('Z_{uu}'); xlabel('t/t_f'); 
%
% A neighboring optimal path:
dt=tf/N; thn=th; sn=s; s(:,1)=[u0 v0 0 .01]'; 
for i=1:N
    th(i)=thn(i)-K(i,:)*(s(:,i)-sn(:,i));
    co=cos(th(i)); si=sin(th(i)); u=s(1,i); v=s(2,i); 
    s(:,i+1)=s(:,i)+dt*[co; si-g; u+dt*co/2; v+dt*(si-g)/2];
end; thh=[th th(N)]; u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:);  
%
figure(1); subplot(311), plot(x,y,'r--',x(N1),y(N1),'ro',...
  x(1),y(1),'ro'); subplot(312), plot(t,u,'r--',t,v,'r--'); 
subplot(313), zohplot(t,z*thh,'r--'); 
%
% Exact neighboring optimum path for comparison:
s0=[u0 v0 0 .01]'; th=dopc('dtdpgic',th,s0,tf,k,tol,mxit); 
[th,s]=dop0n2('dtdpgicn',th,s0,tf,tol); 
thh=[th th(N)]; u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:);  
%
figure(1); subplot(311), plot(x,y,'r.'); hold off
subplot(312), plot(t,u,'r.',t,v,'r.'); hold off
subplot(313), zohplot(t,z*thh,'r.'); hold off
