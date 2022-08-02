% Script p8_4_02.m; max range w. uc=Vy/h using DOP0N2, and a
% neighboring optimum path;                         4/97, 8/10/02
%
N=24; u0=[1:-2/N:-1+2/N]; N1=N+1; s0=[0 0]'; tf=2; c=180/pi;
t=tf*[0:1/N:1]; tol=1e-7;
[u,s,K,Hu,Zuu]=dop0n2('dzrm0n',u0,s0,tf,tol);
x=s(1,:); y=s(2,:); uh=c*[u u(N)]; Kh=[K; K(N,:)];
Zuuh=[Zuu Zuu(N)]; Huh=[Hu Hu(N)];
%
figure(1); clf; subplot(311), plot(x,y,x(1),y(1),'bo',x(N1),...
  y(N1),'bo'); grid; xlabel('x/h'); ylabel('y/h'); 
axis([0 2.5 -.12 .6]); hold on; subplot(312), zohplot(t,uh); grid
ylabel('\theta (deg)'); axis([0 2 -50 50]); hold on; subplot(313)
zohplot(t,Kh'); grid; ylabel('K_y'); axis tight; xlabel('Vt/h')
%
% A neighboring optimum path using perturbation feedback;
dt=tf/N; un=u; sn=s; s(:,1)=[0 -.1]'; 
for i=1:N
    u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i));
    co=cos(u(i)); si=sin(u(i));
    s(:,i+1)=s(:,i)+dt*[co+s(2,i)+dt*si/2; si];
end; uh=c*[u u(N)]; x=s(1,:); y=s(2,:); 
%
subplot(311), plot(x,y,'r--',x(1),y(1),'ro',x(N1),y(N1),'ro');
subplot(312), zohplot(t,uh,'r--'); 
%
% Exact neighboring optimum path for comparison:
s0=[0 -.1]'; [ue,s]=dop0n2('dzrm0n',u0,s0,tf,tol);
xe=s(1,:); ye=s(2,:); uhe=c*[ue ue(N)];    
%
subplot(311), plot(xe,ye,'r.'); hold off 
subplot(312), zohplot(t,uh,'r.'); hold off
%
figure(2); clf; subplot(211), zohplot(t,Zuuh); grid
ylabel('Z_{uu}'); subplot(212), zohplot(t,Huh); grid
ylabel('H_u'); xlabel('Vt/h') 
  
	