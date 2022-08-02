% Script p8_4_04.m; DVDP for max range w. V=1+y (Fermat Pb.) w. quad.
% penalty on (y-yf) using DOP0N2; s=[x y]'; also a nbr. opt. path &
% corres. exact nbr. path;                              4/97, 8/10/02 
%
clear; clear global; global yf sy; yf=2; sy=100; N=20; 
u0=(pi/6)*ones(1,N); s0=[0 0]'; N1=N+1; tol=.001; mxit=8; tf=2;
k=-2; u=dop0('dferm1',u0,s0,tf,k,tol,mxit); tol=1e-7; t=tf*[0:1/N:1]; 
[u,s,K,Hu,Zuu]=dop0n2('dferm1n',u,s0,tf,tol); x=s(1,:); y=s(2,:); 
uh=[u u(N)]; Kh=[K; K(N,:)]; Huh=[Hu Hu(N)]; Zuuh=[Zuu Zuu(N)];
c=180/pi;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'bo',0,0,'bo'); grid
xlabel('x'); ylabel('y'); hold on
%
figure(2); clf; subplot(211), zohplot(t,c*uh); grid 
ylabel('\theta (deg)'); hold on; subplot(212), zohplot(t,Kh');
grid; ylabel('K_y'); xlabel('Time')
%
figure(3); clf; subplot(211), zohplot(t,Huh); grid; ylabel('H_u')
subplot(212), zohplot(t,Zuuh); grid; ylabel('Z_{uu}')
xlabel('Time')
%
% A neighboring optimal path:
dt=tf/N; un=u; xn=s(1,:); yn=s(2,:); x(1)=0; y(1)=.1; 
for i=1:N
    u(i)=un(i)-K(i,1)*(x(i)-xn(i))-K(i,2)*(y(i)-yn(i));
    si=sin(u(i)); a=exp(si*dt); co=cos(u(i)); ta=tan(u(i)); 
    x(i+1)=x(i)+(1+y(i))*(a-1)/ta;
    y(i+1)=a*(1+y(i))-1;
end; uh=[u u(N)];   
%
figure(1); plot(x,y,'r--',x(N1),y(N1),'ro',x(1),y(1),'ro');
figure(2); subplot(211), zohplot(t,c*uh,'r--');
%
% Exact neighboring optimum path for comparison:
s0=[0 .1]'; [u,s]=dop0n2('dferm1n',un,s0,tf,tol); uh=[u u(N)];
x=s(1,:); y=s(2,:);
%
figure(1); plot(x,y,'r.'); hold off
figure(2); subplot(211), zohplot(t,c*uh,'r.'); hold off
 
