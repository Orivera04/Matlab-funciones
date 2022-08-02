% Script e08_7_2.m; TDP for max uf w. spec. (vf,yf) using FOP0N2,
% & a nbr. opt. path; s=[u v y x]'; (cf. p3_4_06.m)            6/22/02
%
load p2_4_9; name='tdp0'; s0=zeros(4,1); tf=1; %k=-1e-4; told=1e-4;
%tols=1e-4; mxit=2; [tu,uf,s]=fop0(name,tu,th0,tf,s0,k,told,tols,mxit);
tol=1e-4; mxit=2; uf=th0; [t,uf,s,K]=fop0n2(name,tu,uf,s0,tf,tol,mxit); 
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); N1=length(t); th=uf;  
%
figure(1); clf; plot(x,y,x(N1),y(N1),'bo'); grid; hold on
axis([0 .42 0 .3]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,180*th/pi); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid 
xlabel('t/t_f'); legend('u/at_f','v/at_f',2); hold on
%
figure(3); clf; plot(t,K(:,2:3)'); grid; xlabel('t/t_f')
ylabel('Fdbk Gains'); legend('K_v','K_y',2); 
%

flg=2; if flg==1

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

end