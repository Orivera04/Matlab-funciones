% Script p8_4_05.m; DVDP for max range w. gravity, thrust, and spec.
% yf; s=[v x y]'; t in tf, a in g, v in g*tf, (x,y) in g*tf^2;     
%                                                      4/97, 8/10/02
%
global a yf sy; a=.5; yf=.1; sy=2e3; tf=1; ga0=(pi/2)*[-1:.05:.6];
s0=[0 0 0]'; k=-35; tol=1e-6; mxit=10; c=180/pi; 
[ga,s]=dopc('dvdpct',ga0,s0,tf,k,tol,mxit); 
[ga,s,K,Hu,Zuu]=dop0n2('dvdpctn',ga,s0,tf,tol); x=s(2,:); y=s(3,:);
N=length(ga); N1=N+1; t=tf*[0:N]/N; gah=[ga ga(N)]; Kh=[K; K(N,:)];
Huh=[Hu Hu(N)]; Zuuh=[Zuu Zuu(N)];
%
figure(1); clf; plot(x,y,x(N1),y(N1),'bo',0,0,'bo'); grid
axis([0 .36 -.14 .13]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')
hold on
%
figure(2); clf; subplot(211), zohplot(t,c*gah); grid 
ylabel('\gamma (deg)'); axis([0 1 -90 70]); hold on; subplot(212)
zohplot(t,Kh'); grid; xlabel('t/t_f'); ylabel('Fdbk Gains')
axis([0 1 0 220]); legend('K_v','K_x','K_y',2)
%
figure(3); clf; subplot(211), zohplot(t,Huh); grid; ylabel('H_u')
subplot(212), zohplot(t,Zuuh); grid; ylabel('Z_{uu}')
xlabel('Time')
%
% A neighboring optimal path:
dt=tf/N; gan=ga; sn=s; s(:,1)=[0 0 .01]'; 
for i=1:N
    ga(i)=gan(i)-K(i,:)*(s(:,i)-sn(:,i));
    co=cos(ga(i)); si=sin(ga(i)); v=s(1,i);  
    s(:,i+1)=s(:,i)+[(a-si)*dt; co*dt*(v+(a-si)*dt/2); ...
       si*dt*(v+(a-si)*dt/2)]; 
end; gah=[ga ga(N)]; x=s(2,:); y=s(3,:);  
%
figure(1); plot(x,y,'r--',x(N1),y(N1),'ro',x(1),y(1),'ro');
figure(2); subplot(211), zohplot(t,c*gah,'r--');
%
% Exact neighboring optimum path for comparison:
s0=[0 0 .01]'; [ga,s]=dop0n2('dvdpctn',ga,s0,tf,tol); gah=[ga ga(N)];
x=s(2,:); y=s(3,:);
%
figure(1); plot(x,y,'r.'); hold off
figure(2); subplot(211), zohplot(t,c*gah,'r.'); hold off
 
	