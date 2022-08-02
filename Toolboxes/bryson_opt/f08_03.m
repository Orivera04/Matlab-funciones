% Script f08_03.m; DTDP for max uf w. spec. (vf,yf) using DOP0N2,
% & a nbr. opt. path; s=[u v y x]';                  5/97, 6/11/02
%
N=20; th0=(pi/3)*[1:-2/N:-1+2/N]; s0=[0 0 0 0]'; tf=1; tol=1e-3;
global vf yf; vf=0; yf=.2; k=-7; mxit=12; t=[0:1/N:1];
th=dopc('dtdpc',th0,s0,tf,k,tol,mxit); tol=1e-7; c=180/pi; 
[th,s,K]=dop0n2('dtdp0n2',th,s0,tf,tol); u=s(1,:); v=s(2,:); 
y=s(3,:); x=s(4,:); thh=c*[th th(N)]; Kh=[K; K(N,:)]; 
%
figure(1); clf; plot(x,y,x(21),y(21),'bo'); grid; hold on
axis([0 .42 0 .3]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid; hold on
ylabel('\theta (deg)'); subplot(212), plot(t,[u; v]); grid 
xlabel('t/t_f'); legend('u/at_f','v/at_f',2); hold on
%
figure(3); clf; zohplot(t,Kh(:,2:3)'); grid; xlabel('t/t_f')
ylabel('Fdbk Gains'); legend('K_v','K_y',2); 
%
% A neighboring optimum path using perturbation feedback;
dt=tf/N; thn=th; sn=s; ds=zeros(4,N+1); dth=zeros(1,N);
ds(:,1)=[0 0 .03 0]'; 
for i=1:N
    co=cos(thn(i)); si=sin(thn(i));
    dth(i)=-K(i,:)*ds(:,i); 
    fs=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];
    fu=dt*[-si co dt*co/2 -dt*si/2]';
    ds(:,i+1)=fs*ds(:,i)+fu*dth(i);
end; th=thn+dth; thh=c*[th th(N)]; thnh=c*[thn thn(N)];
s=sn+ds; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); 
%
figure(1); plot(x,y,'r--',x(21),y(21),'ro'); hold off
figure(2); subplot(211), zohplot(t,thh,'r--'); subplot(212)
plot(t,[u; v],'r--'); hold off

