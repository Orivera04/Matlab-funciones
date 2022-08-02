% Script p3_4_01.m; VDP for max xf with gravity & spec. yf; s=[V y x]';
%                                                          2/97, 7/16/02
%
name='vdpc'; N=20; tf=1; tu=tf*[0:1/N:1]'; u=[1:-1/N:0]'; ;
s0=[0 0 0]'; k=-1; told=1e-4; tols=1e-4; mxit=6; global yf; yf=.3;
[t,u,s,nu,la0]=fopc(name,tu,u,tf,s0,k,told,tols,mxit);
y=s(:,2); x=s(:,3); N1=length(y);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro',0,0,'ro'); grid
axis([0 .35 -.35 0]); axis('square'); ylabel('y/gt_f^2')
xlabel('x/gt_f^2')

	