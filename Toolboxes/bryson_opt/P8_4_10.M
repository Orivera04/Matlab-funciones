% Script p8_4_10.m; DTDP for max uf w. gravity & spec. (vf,yf,xf)
% using DOP0N2; s=[u v y x]'; t in tf, (u v) in a*tf, (x y) in a*tf^2,
% g in a;                                                 4/97, 8/10/02
%
clear; clear global; global yf xf g sf; yf=.2; xf=.15; g=1/3; sf=2e4; 
N=14; th0=(pi/3)*[1:-2/N:-1+2/N]; s0=[0 0 0 0]'; tf=1; k=-1; tol=1e-4;
mxit=25; t=[0:N]/N; [th,s,nu,la0]=dopc('dtdpgcx',th0,s0,tf,k,tol,mxit);
tol=1e-6; [th,s,K,Hu,Zuu]=dop0n2('dtdpgcxn',th,s0,tf,tol); thh=[th th(N)];
u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); Kh=[K; K(N,:)]; z=180/pi;
N1=N+1; Huh=[Hu Hu(N)]; Zuuh=[Zuu Zuu(N)];
%
figure(1); clf; plot(x,y,0,0,'bo',x(N1),y(N1),'bo'); grid
axis([-.02 .2 0 .22]); axis('square'); xlabel('x/at_f^2')
ylabel('y/at_f^2'); hold on
%
figure(2); clf; subplot(211), zohplot(t,z*thh); grid; hold on
ylabel('\theta (deg)'); axis tight; subplot(212)
plot(t,u,t,v,'b--'); grid; xlabel('t/t_f'); axis([0 1 0 .55])
hold on; legend('u/at_f','v/at_f',2)
%
figure(3); clf; subplot(311), zohplot(t,Kh'); grid; axis tight
ylabel('Fdbk Gains'); legend('K_u','K_v','K_y','K_x',2)
subplot(312), zohplot(t,Huh); grid; ylabel('H_u'); subplot(313)
zohplot(t,Zuuh); grid; ylabel('Z_{uu}'); xlabel('t/t_f');
%
% A neighboring optimal path:
dt=tf/N; thn=th; sn=s; s(:,1)=[0 0 .01 0]'; 
for i=1:N
    th(i)=thn(i)-K(i,:)*(s(:,i)-sn(:,i));
    co=cos(th(i)); si=sin(th(i)); u=s(1,i); v=s(2,i); 
    s(:,i+1)=s(:,i)+dt*[co; si-g; v+dt*(si-g)/2; u+dt*co/2; ];
end; thh=[th th(N)]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);  
%
figure(1); plot(x,y,'r--',x(N1),y(N1),'ro',x(1),y(1),'ro');
figure(2); subplot(211), zohplot(t,z*thh,'r--'); 
subplot(212), plot(t,u,'r--',t,v,'r--'); 
%
% Exact neighboring optimum path for comparison:
s0=[0 0 .01 0]'; th=dopc('dtdpgcx',th,s0,tf,k,tol,mxit); 
[th,s]=dop0n2('dtdpgcxn',th,s0,tf,tol); 
thh=[th th(N)]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);  
%
figure(1); plot(x,y,'r.'); hold off
figure(2), subplot(211), zohplot(t,z*thh,'r.'); hold off
subplot(212), plot(t,u,'r.',t,v,'r.'); hold off

